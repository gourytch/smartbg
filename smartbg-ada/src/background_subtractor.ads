generic
   type Colour_Type is (<>);
   Width 	: in Positive;
   Height	: in Positive;
   MRU_Size	: in Positive;
   with function Distance (A, B : Colour_Type) return Natural; -- nonnegative

package Background_Subtractor is

   type Range_100 is range 0 .. 100; -- 0%..100%

   type Frame_Type is array (1..Width, 1..Height) of Colour_Type;

   type Feedback_Type is (
                          None, -- I have no decision about this point.
                          Keep,	-- this is object. keep value of this point
                          Merge -- this is not object. merge it to background
                         );

   type Feedback_Matrix_Type is array (1..Width, 1..Height) of Feedback_Type;

   type Mask_Type is (
                      Skip, -- Skip this pixel.
                      Check -- check this pixel
                     );

   type Mask_Matrix_Type is array (1..Width, 1..Height) of Mask_Type;

   type Result_Type is (
                      Background, -- this is background pixel
                      Foreground --  this is foreground pixel
                       );

   type Result_Matrix_Type is array (1..Width, 1..Height) of Result_Type;

   type Subtractor is limited private;

   procedure Initialize (Obj : in out Subtractor);

   procedure Set_Colour_Distance (Obj : in out Subtractor;
                                  Distance : in Natural);

   procedure Set_Probability_Update (Obj : in out Subtractor;
                                     Probability : in Range_100);

   procedure Set_Probability_Merge (Obj : in out Subtractor;
                                    Probability : in Range_100);

   procedure Set_Feedback (Obj : in out Subtractor;
                           Feedback : in Feedback_Matrix_Type);

   procedure Set_Mask (Obj : in out Subtractor;
                       Mask : in Mask_Matrix_Type);

   procedure Get_Result (Obj : in out Subtractor;
                         Result : out Result_Matrix_Type);

   procedure Process_Frame (Obj : in out Subtractor;
                            Frame : in Frame_Type);


private

   type MRU_Matrix is array (1..Width, 1..Height, 1..MRU_Size) of Colour_Type;

   type Subtractor is limited record
      Backgrounds : MRU_Matrix;
      Feedback    : Feedback_Matrix_Type;
      Mask        : Mask_Matrix_Type;
      Result      : Result_Matrix_Type;
      Is_Virgin   : Boolean;

      Colour_Distance    : Natural;
      Probability_Update : Range_100; -- 0..100
      Probability_Merge  : Range_100;
   end record;


end Background_Subtractor;
