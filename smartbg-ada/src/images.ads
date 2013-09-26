package Images is

   type Pixel_Value is mod 2 ** 8;

   type Position is Positive (<>);

   type Image is private;

   procedure Create(Img    : in out Image;
                    Width  : in     Natural;
                    Height : in     Natural);

   function Get(Img : in Image;
                X   : in  Natural;
                Y   : in  Natural);

   function Put(Img : in out Image;
                X   : in     Natural;
                Y   : in     Natural;
                Px  : in     Pixel_Value);
private

   type Image is

end Images;
