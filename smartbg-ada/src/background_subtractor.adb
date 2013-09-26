with Ada.Numerics.Discrete_Random;

package body Background_Subtractor is

   type Neighbour_Index is range 1 .. 8;
   package Neighbour_Generator is new Ada.Numerics.Discrete_Random
     (Result_Subtype => Neighbour_Index);
   Neighbour_Seed : Neighbour_Generator.Generator;

   -- for 0..99 random number generation
   subtype Range_99 is Range_100 range
     Range_100'First .. Range_100'Pred(Range_100'Last);

   package Generator_99 is new Ada.Numerics.Discrete_Random
     (Result_Subtype => Range_99);
   Seed_99 : Generator_99.Generator;


   procedure Initialize (Obj : in out Subtractor) is
   begin
      Obj.Feedback := (others => (others => None));
      Obj.Mask := (others => (others => Check));
      Obj.Backgrounds := (others => (others => (others => Colour_Type'First)));
      Obj.Result := (others => (others => Background));
   end Initialize;


   procedure Set_Colour_Distance (Obj : in out Subtractor;
                                  Distance : in Natural) is
   begin
      Obj.Colour_Distance := Distance;
   end Set_Colour_Distance;


   procedure Set_Probability_Update (Obj : in out Subtractor;
                                     Probability : in Range_100) is
   begin
      Obj.Probability_Update := Probability;
   end Set_Probability_Update;


   procedure Set_Probability_Merge (Obj : in out Subtractor;
                                    Probability : in Range_100) is
   begin
      Obj.Probability_Merge := Probability;
   end Set_Probability_Merge;



   procedure Set_Feedback (Obj : in out Subtractor;
                           Feedback : in Feedback_Matrix_Type) is
   begin
      Obj.Feedback := Feedback;
   end Set_Feedback;


   procedure Set_Mask (Obj : in out Subtractor;
                       Mask : in Mask_Matrix_Type) is
   begin
      Obj.Mask := Mask;
   end Set_Mask;


   procedure Get_Result (Obj : in out Subtractor;
                         Result : out Result_Matrix_Type) is
   begin
      Result := Obj.Result;
   end Get_Result;


   procedure Process_Frame (Obj : in out Subtractor;
                            Frame : in Frame_Type) is

      function Choice (Min, Max : Positive) return Positive is
      begin
         return Min + (Max - Min) / 2; -- stub;
      end Choice;

      procedure Update_Background (X, Y : Positive) is
      begin
         Obj.Backgrounds (X, Y, Choice (1 , MRU_Size)) := Frame (X, Y);
      end Update_Background;


      function Want_To_Update_Background return Boolean is
         use Generator_99;
      begin
         return Random (Seed_99) < Obj.Probability_Update;
      end Want_To_Update_Background;

      function Want_To_Update_Foreground return Boolean is
         use Generator_99;
      begin
         return Random (Seed_99) < Obj.Probability_Merge;
      end Want_To_Update_Foreground;



      function Is_Background (X, Y : in Positive) return Boolean is

         procedure Swap (A, B : in out Colour_Type) is
            Tmp : constant Colour_Type := A;
         begin
            A := B;
            B := Tmp;
         end Swap;

         Colour : constant Colour_Type := Frame (X, Y);

      begin
         for Ix in 1 .. MRU_Size loop
            if Distance (Colour, Obj.Backgrounds (X, Y, Ix))
              <= Obj.Colour_Distance then
               -- matched
               if 1 < Ix then -- raise mru entry
                  Swap (Obj.Backgrounds (X, Y, Ix),
                        Obj.Backgrounds (X, Y, Ix - 1));
               end if;
               return True;
            end if;
         end loop;
         return False;
      end Is_Background;

      function Random_Neighbour_Is_Background (X, Y : in Positive)
                                               return Boolean is
         use Neighbour_Generator;

         Neighbour_X : constant array (Neighbour_Index) of Integer :=
           (-1, +0, +1,
            -1,     +1,
            -1, +0, +1);
         Neighbour_Y : constant array (Neighbour_Index) of Integer :=
           (-1, -1, -1,
            +0,     +0,
            +1, +1, +1);
         Ix : constant Neighbour_Index := Random (Neighbour_Seed);
         New_X : Integer := Neighbour_X (Ix);
         New_Y : Integer := Neighbour_Y (Ix);
      begin
         if (1 = X and then New_X < 0)
           or else (Width = X and then 0 < New_X)
         then
            New_X := X;
         else
            New_X := New_X + X;
         end if;

         if (1 = Y and then New_Y < 0)
           or else (Height = Y and then 0 < New_Y)
         then
            New_Y := Y;
         else
            New_Y := New_Y + Y;
         end if;

         return Obj.Result (New_X, New_Y) = Background;
      end Random_Neighbour_Is_Background;


      begin
         for Y in 1 .. Height loop
            for X in 1 .. Width loop
               if Obj.Mask (X, Y) = Check then
                  if Obj.Feedback (X, Y) = Merge then
                     Obj.Result (X, Y) := Background;
                     Update_Background (X, Y);
                  else -- no forced merging performed
                     if Is_Background (X, Y) then
                        -- here is background colour
                        Obj.Result (X, Y) := Background;
                        if Obj.Feedback (X, Y) /= Keep
                          and then Want_To_Update_Background
                        then
                           Update_Background (X, Y);
                        end if;
                     else -- this is foreground colour
                        if Obj.Feedback (X, Y) /= Keep
                          and then Want_To_Update_Foreground
                          and then Random_Neighbour_Is_Background (X, Y)
                        then -- we want to merge this pixel to background
                           Update_Background (X, Y);
                           Obj.Result (X, Y) := Background;
                        else  -- mark this pixel as foreground
                           Obj.Result (X, Y) := Foreground;
                        end if;
                     end if; -- Is_Background
                  end if;
               end if;
            end loop;
         end loop;
      end Process_Frame;



   end Background_Subtractor;
