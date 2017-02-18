//   _____                                    ___
//  |        ____                            /   \    ___                ___             _____
//  |____   /    \   |     |   |/    ____    \___    /   \    |     |   /   \|    |/    /_____\
//  |      |      |  |     |   |                 \  |     |   |     |  |     |    |    |
//  |       \____/    \___/    |             \___/   \___/|    \___/    \___/ \   |     \_____/
//                                                        |
//                                                        |
//////////////////////////////////
//                              //
//  //||//||//||  //||//||//||  //
//  //||//||//||  //||//||//||  //
//  //||//||//||  //||//||//||  //
//  //||//||//||  //||//||//||  //
//  //||//||//||  //||//||//||  //
//                              //
//  //||//||//||  //||//||//||  //
//  //||//||//||  //||//||//||  //
//  //||//||//||  //||//||//||  //
//  //||//||//||  //||//||//||  //
//  //||//||//||  //||//||//||  //
//                              //
//////////////////////////////////

unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls, ComCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    ProgressBar1: TProgressBar;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Memo3Change(Sender: TObject);
    procedure Memo4Change(Sender: TObject);
    procedure Memo5Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure work();
    procedure encrypt();
    procedure decrypt();
    procedure init_arrays();
    procedure WriteToGrid();
    procedure CalculateLines(i1, i2, i3, i4: Integer);
  private
    x1,y1,x2,y2:Integer;
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  squares: array[1..4,0..4,0..4] of char;
  auto: Boolean;
  abc_without_w: String = 'ABCDEFGHIJKLMNOPQRSTUVXYZ';

implementation

{$R *.lfm}

{ TForm1 }

// Prefills the Memos with Examples
// Starts Init and WritetToGrid procedures
// Encrypts the Example
procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Text:='THISISAGREATEXAMPLE';                                                                                                                                                                                                                    //Example text to encrypt
  Memo2.Text:='';                                                                                                                                                                                                                                       //Clear Memo2
  Memo3.Text:='ZYXVUTSRQPONMLKJIHGFEDCBA';                                                                                                                                                                                                              //Alphabeth backwards as standard key
  Memo4.Text:='ZYXVUTSRQPONMLKJIHGFEDCBA';                                                                                                                                                                                                              //Alphabeth backwards as standard key
  Memo5.Text := 'You can only use the characters from A to Z except of W. Every character can only and has to be used once. If the keys are not correct the encryption may not work properly. Alternativly you can use the key generator.';             //Explanaition for key usage
  init_arrays();                                                                                                                                                                                                                                        //init the square-array
  WriteToGrid();                                                                                                                                                                                                                                        //write the alphabeth and the keys into the grid
  auto:=true;                                                                                                                                                                                                                                           //set the automatic encrytion to true
end;

// Decrypt Encrypted / Encrypt Decrypted
procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Text:=Memo2.Text;
  if RadioButton1.Checked then
     RadioButton2.Checked := true
  else
     RadioButton1.Checked := true;
end;

//Start En-/Decryption
procedure TForm1.Button2Click(Sender: TObject);
begin
     work();
end;

//Key Generator
procedure TForm1.Button3Click(Sender: TObject);
var
  current_char: String;
  char_to_check: Integer;
  is_there: Boolean;
begin
  ProgressBar1.Position:=0;                                 // Reset the
  ProgressBar1.Max:=50;                                     // ProgressBar

  Memo3.Text:='';                                           // Reset the first key-text-field
  Memo4.Text:='';                                           // Reset the second key-text-field

  Randomize();                                              // Randomize for random key

  while Length(Memo3.Text) < 25 do                          //
  begin                                                     //
      is_there := false;                                    //
      current_char:=abc_without_w[Random(26)];              // choose random character from the alphabeth (except w)

      for char_to_check:=1 to Length(Memo3.Text) do         // \
      begin                                                 //  \
          if Memo3.Text[char_to_check] = current_char then  //   \
          begin                                             //    \
             is_there := true;                              //     \ Check if character
          end;                                              //     / is alredy in use
      end;                                                  //    /
      if is_there = false then                              //   /
      begin                                                 //  /
         Memo3.Text := Memo3.Text + current_char;           //  add char to key
         ProgressBar1.Position:=ProgressBar1.Position + 1;  //  update ProgressBar-Position
      end;                                                  //
  end;                                                      //

  while Length(Memo4.Text) < 25 do                          // _
  begin                                                     //  \
      is_there := false;                                    //   |
      current_char:=abc_without_w[Random(26)];              //   |
      for char_to_check:=1 to Length(Memo4.Text) do         //   |
      begin                                                 //   |
          if Memo4.Text[char_to_check] = current_char then  //   |
          begin                                             //   \
             is_there := true;                              //    -- for detailed see the while loop above
          end;                                              //   /
      end;                                                  //   |
      if is_there = false then                              //   |
      begin                                                 //   |
         Memo4.Text := Memo4.Text + current_char;           //   |
         ProgressBar1.Position:=ProgressBar1.Position + 1;  //   |
      end;                                                  //  /
  end;                                                      // -

  Memo3Change(Memo3);                                       // -> check for possible errors and writes the new key into the grid
  Memo4Change(Memo4);                                       // -> check for possible errors and writes the new key into the grid

  work();                                                   // -> starting en- or decrypting with the new strings
end;

//En- or Disable Autoencryption
procedure TForm1.CheckBox1Change(Sender: TObject);
begin
     if CheckBox1.Checked then
     begin
        Button2.Visible:=false;
        auto:=true;
     end
     else
     begin
        Button2.Visible:=true;
        auto:=false;
     end;
end;

// Writes the Alphabeth into the Array
// Also writes the prefilled Keys into the Array
procedure TForm1.init_arrays();
var
  i1: integer = 0;
  i2: integer = 0;
begin

  //Writing the standard alphabeth into squares[1]
  for i1:=0 to 4 do
  begin
      for i2:=0 to 4 do
      begin
          squares[1][i1][i2]:=abc_without_w[i1*5+i2+1];
      end;
  end;

  //Writing the standard alphabeth into squares[4]
  for i1:=0 to 4 do
  begin
      for i2:=0 to 4 do
      begin
          squares[4][i1][i2]:=abc_without_w[i1*5+i2+1];
      end;
  end;

  //Writing the prefilled key into squares[2]
  for i1:=0 to 4 do
  begin
      for i2:=0 to 4 do
      begin
          squares[2][i1][i2]:=Memo4.Text[i1*5+i2+1];
      end;
  end;

  //Writing the prefilled key into squares[3]
  for i1:=0 to 4 do
  begin
      for i2:=0 to 4 do
      begin
          squares[3][i1][i2]:=Memo3.Text[i1*5+i2+1];
      end;
  end;
end;

// Start En- or Decrypting on change
// Replacing illegal characters
procedure TForm1.Memo1Change(Sender: TObject);
var
  Changed_String: String;
  i1, i2:Char;
  is_there: Boolean;
begin
  Changed_String:=UpperCase(Memo1.Text);
  Changed_String:=StringReplace(Changed_String, 'W', 'VV', [rfReplaceAll]);
  Changed_String:=StringReplace(Changed_String, 'ä', 'AE', [rfReplaceAll]);  //   \
  Changed_String:=StringReplace(Changed_String, 'ö', 'OE', [rfReplaceAll]);  //    \
  Changed_String:=StringReplace(Changed_String, 'ü', 'UE', [rfReplaceAll]);  //     \  Flag rfIgnoreCase is not
  Changed_String:=StringReplace(Changed_String, 'Ä', 'AE', [rfReplaceAll]);  //     /  working for unknown reason
  Changed_String:=StringReplace(Changed_String, 'Ö', 'OE', [rfReplaceAll]);  //    /
  Changed_String:=StringReplace(Changed_String, 'Ü', 'UE', [rfReplaceAll]);  //   /
  Changed_String:=StringReplace(Changed_String, 'ß', 'SS', [rfReplaceAll]);

  for i1 in Changed_String do                                                     //  |
  begin                                                                           //  |
      is_there:=false;                                                            //  |
       for i2 in abc_without_w do                                                 //  |   Removing every character
           if i1 = i2 then                                                        //  |   that is not in the list
              is_there:=true;                                                     //  |   of allowed characters
       if is_there = false then                                                   //  |
           Changed_String:=StringReplace(Changed_String, i1, '', [rfReplaceAll]); //  |
  end;                                                                            //  |

  if Memo1.Text <> Changed_String then                                            //  |
  begin                                                                           //  |   Only work() and write
     Memo1.Text:=Changed_String;                                                  //  |   in Memo if the String
     if auto then                                                                 //  |   really has changed
        work();                                                                   //  |   (Avoiding Loop)
  end;                                                                            //  |
end;

//Write the Keys into the Array
//Check if keys arent containing any illegal characters
procedure TForm1.Memo3Change(Sender: TObject);
var
  i1: integer = 0;
  i2: integer = 0;
  is_there:Boolean;
  current_char, char_to_check: Char;
begin
  if Memo3.Text <> '' then
  begin
  Memo3.Text:=UpperCase(Memo3.Text);

  for current_char in Memo3.Text do                                                   //  |
  begin                                                                               //  |
       is_there:=false;                                                               //  |
       for char_to_check in abc_without_w do                                          //  |   Removing every character
           if current_char = char_to_check then                                       //  |   that is not in the list
              is_there:=true;                                                         //  |   of allowed characters
       if is_there = false then                                                       //  |
           Memo3.Text:=StringReplace(Memo3.Text, current_char, '', [rfReplaceAll]);   //  |
  end;

  for i1:=0 to 4 do                                                                  //  \
  begin                                                                              //   \
      for i2:=0 to 4 do                                                              //    \
      begin                                                                          //     | Write the Key into the array by looping through it
          squares[2][i1][i2]:=Memo3.Text[i1*5+i2+1];                                 //    /
      end;                                                                           //   /
  end;                                                                               //  /

  WriteToGrid();
  work();
  end;
end;
procedure TForm1.Memo4Change(Sender: TObject);
var
  i1: integer = 0;
  i2: integer = 0;
  is_there:Boolean;
  current_char, char_to_check: Char;
begin
  if Memo4.Text <> '' then
  begin
  Memo4.Text:=UpperCase(Memo4.Text);

  for current_char in Memo4.Text do                                                   //  |
  begin                                                                               //  |
       is_there:=false;                                                               //  |
       for char_to_check in abc_without_w do                                          //  |   Removing every character
           if current_char = char_to_check then                                       //  |   that is not in the list
              is_there:=true;                                                         //  |   of allowed characters
       if is_there = false then                                                       //  |
           Memo4.Text:=StringReplace(Memo4.Text, current_char, '', [rfReplaceAll]);   //  |
  end;

  for i1:=0 to 4 do                                                                  //  \
  begin                                                                              //   \
      for i2:=0 to 4 do                                                              //    \
      begin                                                                          //     | Write the Key into the array by looping through it
          squares[3][i1][i2]:=Memo4.Text[i1*5+i2+1];                                 //    /
      end;                                                                           //   /
  end;                                                                               //  /

  WriteToGrid();
  work();
  end;
end;

//Explanation of key usage
procedure TForm1.Memo5Change(Sender: TObject);
begin
     // Rewrite this Text into the memo every time someone trying to change it
     Memo5.Text := 'You can only use the characters from A to Z except of W. Every character can only and has to be used once. If the keys are not correct the encryption may not work properly. Alternativly you can use the key generator.';
end;

// Change between En- and Decryption (starting the work() procedure)
procedure TForm1.RadioButton1Change(Sender: TObject);
begin
  work();
end;
procedure TForm1.RadioButton2Change(Sender: TObject);
begin
  work();
end;

// Adding draw Lines to the StringGrid DrawCell method
procedure TForm1.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
     StringGrid1.Canvas.Pen.Color:=clred;      // set the pen color     |    (x1|y1)------1------(x2|y1)
     StringGrid1.Canvas.Line(x1,y1,x2,y1);     // 1                     |       |                   |
     StringGrid1.Canvas.Line(x1,y1,x1,y2);     // 2                     |       2                   4
     StringGrid1.Canvas.Line(x1,y2,x2,y2);     // 3                     |       |                   |
     StringGrid1.Canvas.Line(x2,y1,x2,y2);     // 4                     |    (x1|y2)------3------(x2|y2)
end;

// Start En- or Decrypting
procedure TForm1.work();
begin
     if RadioButton1.Checked = true then
        encrypt()
     else
        decrypt();
end;

// Encrypt
procedure TForm1.encrypt();
var
  text_to_encrypt: String;
  encrypted: String;
  current1: char;
  current2: char;
  currentchar1: char;
  currentchar2: char;
  i2: Integer = 0;
  i3: Integer = 0;
  i4: Integer = 0;
  i5: Integer = 0;
  i6: Integer = 0;
begin
     if Memo1.Text <> '' then
          begin
               encrypted:='';
               ProgressBar1.Position:=0;                                        // reset the PrograssBar
               text_to_encrypt:=Memo1.Text;                                     //
               if (Length(text_to_encrypt) mod 2) = 1 then                      // \
               begin                                                            //  | make the length of the text even by
                  text_to_encrypt:=text_to_encrypt+'X';                         //  | adding 'X' to texts of odd lengths
               end;                                                             // /

               ProgressBar1.Max:=Length(text_to_encrypt);                       // set the end of the ProgressBar to the length of the text

               for i2:=1 to Length(text_to_encrypt) div 2 do                    // run for every second char, because you always have to encrypt to chars at the same time
               begin                                                            //
                   i3:=0;                                                       //
                   i4:=0;                                                       //
                   i5:=0;                                                       //
                   i6:=0;                                                       //
                   current1:=text_to_encrypt[2*i2-1];                           // get the two
                   current2:=text_to_encrypt[2*i2];                             // chars to encrypt
                   currentchar1:=squares[1][0][0];                              //
                   currentchar2:=squares[4][0][0];                              //

                   while current1 <> currentchar1 do                            // -
                   begin                                                        //  \
                        i3:=i3+1;                                               //   |
                        if i3=5 then                                            //   |
                        begin                                                   //    \ find the first char in the standard
                             i3:=0;                                             //    / aphabeth by looping through it
                             i4:=i4+1;                                          //   |
                        end;                                                    //   |
                        currentchar1:=squares[1][i4][i3];                       //  /
                   end;                                                         // -

                   while current2 <> currentchar2 do                            // -
                   begin                                                        //  \
                        i5:=i5+1;                                               //   |
                        if i5=5 then                                            //   |
                        begin                                                   //    \ find the second char in the standard
                             i5:=0;                                             //    / aphabeth by looping through it
                             i6:=i6+1;                                          //   |
                        end;                                                    //   |
                        currentchar2:=squares[4][i6][i5];                       //  /
                   end;                                                         // -

                   encrypted:=encrypted+squares[2][i4][i5];                     // add the char, wich position is a mix of the positions off the two char found before, to the encryptet text
                   ProgressBar1.Position:=ProgressBar1.Position+1;              // move ProgressBar about 1 step
                   encrypted:=encrypted+squares[3][i6][i3];                     // add the char, wich position is a mix of the positions off the two char found before, to the encryptet text
                   ProgressBar1.Position:=ProgressBar1.Position+1;              // move ProgressBar about 1 step
                   Application.ProcessMessages;                                 // Causes the the updated Position of the ProgressBar to be visible before the encryption is over
               end;                                                             //
               CalculateLines(i3, i4, i5, i6);                                  // Starting Calculation
               Memo2.Text:=encrypted;                                           // write encrypted text into memo
          end                                                                   //
          else                                                                  //
              Memo2.Text:='';                                                   // Clears memo2 if memo1 is empty
          if (StringGrid1.Cells[10,4] = '----') or (StringGrid1.Cells[4,10] = '----') then
             Memo2.Text:='The keys are not long enough!';
end;

// Decrypt
procedure TForm1.decrypt();
var
  text_to_decrypt: String;
  decrypted: String;
  current1: char;
  current2: char;
  currentchar1: char;
  currentchar2: char;
  i2: Integer = 0;
  i3: Integer = 0;
  i4: Integer = 0;
  i5: Integer = 0;
  i6: Integer = 0;
begin

  // For detailed information about most of the steps see the encryption function

     if Memo1.Text <> '' then
          begin
               decrypted:='';
               ProgressBar1.Position:=0;
               text_to_decrypt:=Memo1.Text;
               if (Length(text_to_decrypt) mod 2) = 1 then
               begin
                  text_to_decrypt:=text_to_decrypt+'X';
               end;
               ProgressBar1.Max:=Length(text_to_decrypt);
               for i2:=1 to Length(text_to_decrypt) div 2 do
               begin
                   i3:=0;
                   i4:=0;
                   i5:=0;
                   i6:=0;
                   current1:=text_to_decrypt[2*i2-1];
                   current2:=text_to_decrypt[2*i2];
                   currentchar1:=squares[2][0][0];
                   currentchar2:=squares[3][0][0];
                   while current1 <> currentchar1 do
                   begin
                        i3:=i3+1;
                        if i3=5 then
                        begin
                             i3:=0;
                             i4:=i4+1;
                        end;
                        currentchar1:=squares[2][i4][i3];
                   end;
                   while current2 <> currentchar2 do
                   begin
                        i5:=i5+1;
                        if i5=5 then
                        begin
                             i5:=0;
                             i6:=i6+1;
                        end;
                        currentchar2:=squares[3][i6][i5];
                   end;
                   decrypted:=decrypted+squares[1][i4][i5];
                   ProgressBar1.Position:=ProgressBar1.Position+1;
                   decrypted:=decrypted+squares[4][i6][i3];
                   ProgressBar1.Position:=ProgressBar1.Position+1;
                   Memo2.Text:=decrypted;
                   Application.ProcessMessages;
               end;
               CalculateLines(i3, i4, i5, i6);
          end
          else
              Memo2.Text:='';
          if (StringGrid1.Cells[10,4] = '----') or (StringGrid1.Cells[4,10] = '----') then
             Memo2.Text:='The keys are not long enough!'
end;

// Write the 'Four Squares' into the Grid
procedure TForm1.WriteToGrid();
var
  i1: Integer;
  i2: Integer;
begin
  //Square 1
     for i1:=0 to 4 do
     begin
         for i2:=0 to 4 do
         begin
             StringGrid1.Cells[i2,i1]:=squares[1][i1][i2];
         end;
     end;

  //Square 2
     for i1:=0 to 4 do
     begin
         for i2:=0 to 4 do
         begin
             StringGrid1.Cells[i2+6,i1]:=squares[2][i1][i2];
         end;
     end;
   //Clean up Square 2
   for i1:=0 to 4 do
     begin
         for i2:=0 to 4 do
         begin
             if i1*5+i2+1 > Length(Memo3.Text) then
                   StringGrid1.Cells[i2+6,i1]:='----';
         end;
     end;

   //Square 3
     for i1:=0 to 4 do
     begin
         for i2:=0 to 4 do
         begin
             StringGrid1.Cells[i2,i1+6]:=squares[3][i1][i2];
         end;
     end;
   //Clean up Square 3
     for i1:=0 to 4 do
     begin
         for i2:=0 to 4 do
         begin
             if i1*5+i2+1 > Length(Memo4.Text) then
                   StringGrid1.Cells[i2,i1+6]:='----';
         end;
     end;

   //Square 4
     for i1:=0 to 4 do
     begin
         for i2:=0 to 4 do
         begin
             StringGrid1.Cells[i2+6,i1+6]:=squares[4][i1][i2];
         end;
     end;
end;

// Calculate the Points for the Lines
procedure TForm1.CalculateLines(i1, i2, i3, i4: Integer);
var
  cell_size: Integer;
begin
     cell_size:=StringGrid1.Width div StringGrid1.ColCount;                     //Calculat the cell width and height by dividing the total StringGrid-size through the number of colums
     x1:=round(cell_size*(0.5+i1));
     y1:=round(cell_size*(0.5+i2));
     x2:=round(cell_size*(6.5+i3));
     y2:=round(cell_size*(6.5+i4));
     StringGrid1.Refresh;                                                       //-> Lines become visible
end;

end.

