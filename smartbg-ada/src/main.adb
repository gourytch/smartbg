with Background_Subtractor;
procedure Main is

   type Grayscale_Type is mod 2**8;

   function Distance_Grayscale (A, B : Grayscale_Type) return Natural is
   begin
      if A < B then
         return Natural (B - A);
      else
         return Natural (A - B);
      end if;
   end Distance_Grayscale;

   package Grayscale_Subtractor_800x600_8 is new Background_Subtractor
     (Colour_Type => Grayscale_Type,
      Distance => Distance_Grayscale,
      Width => 800,
      Height => 600,
      MRU_Size => 8);
   use Grayscale_Subtractor_800x600_8;

   Sub : Subtractor;
   Frame : Frame_Type;
   Result : Result_Matrix_Type;

begin
   Initialize (Sub);
   Set_Mask (Sub, (others => (others => Check)));
   Set_Feedback (Sub, (others => (others => None)));
   Frame := (others => (others => 0));
   Process_Frame (Sub, Frame);
   Get_Result (Sub, Result);
end Main;
