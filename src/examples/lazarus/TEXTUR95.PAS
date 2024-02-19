unit Textur95;

// Texture95 : Code of the 2D game 'Heroic Huxley' written by Roelof Emmerink (rpe86@hotmail.com)

// This game makes use of Allegro 5. See Allegro5.pas and file LICENSE

interface

uses Crt, Dos;

const A10_X = 16;
      A10_Y = 24;

      A20_X = 20;
      A20_Y = 36;

      B10_X = 80;
      B10_Y = 18;

      C30_X = 32;
      C30_Y = 32;


var TEX_A10 : array[0..2,0..A10_X-1,0..A10_Y-1] of record
                                                     {R, G, B : Byte;}
                                                     Color16{, Color18} : Shortint;
                                                   end;

    TEX_A20 : array[0..2,0..A20_X-1,0..A20_Y-1] of record
                                                     {R, G, B, R256, G256, B256 : Byte;}
                                                     Color16{, Color18} : Shortint;
                                                   end;

    TEX_B10 : array[0..0,0..B10_X-1,0..B10_Y-1] of record
                                                     {R, G, B : Byte;}
                                                     Color16{, Color18} : Shortint;
                                                   end;

    TEX_C30 : array[0..3,0..C30_X-1,0..C30_Y-1] of record
                                                     {R, G, B : Byte;}
                                                     Color16{, Color18} : Shortint;
                                                   end;

    F : file of Byte;
    Dat : array[0..2] of Byte;
    Color : record
              R, G, B : Byte;
            end;

    i, j, k : Integer;

    TransparantCol : Integer;

    R, G, B : Byte;

    Color18 : Shortint;

procedure InitTextures;


implementation

procedure InitTextures;

begin

  { --- }

  Assign(F, 'c:\gametex\flame23.raw');

  Reset(F);

  for k := 0 to {2}0 do
    for j := 0 to A10_Y-1 do
      for i := 0 to A10_X-1 do
      begin
        Read(F, Dat[0]);
        Read(F, Dat[1]);
        Read(F, Dat[2]);
{        TEXT_A10[k,i,j].R := Trunc(Dat[0]/86)*2*3+Trunc(Dat[1]/86)*2+Trunc(Dat[2]/128);}
        R := Trunc(Dat[0]/86);
        G := Trunc(Dat[1]/86);
        B := Trunc(Dat[2]/128);

        Color18 := R*3*2 + G*2 + B;

        TEX_A10[k,i,j].Color16 := Color18;

        case TEX_A10[k,i,j].Color16 of
          16 : TEX_A10[k,i,j].Color16 := 5;
          17 : TEX_A10[k,i,j].Color16 := 7;
        end;
      end;
  Close(F);

  TransparantCol := TEX_A10[0,0,0].Color16; // note : upper-left pixel = transparancy color!!

  for k := 0 to {2}0 do
    for j := 0 to A10_Y-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      i := 0;
      while (TEX_A10[k,i,j].Color16 = TransparantCol) AND (i < A10_X-1) do
      begin
        TEX_A10[k,i,j].Color16 := -1;
        Inc(i);
      end;
      i := A10_X-1;
      while (TEX_A10[k,i,j].Color16 = TransparantCol) AND (i > 0) do
      begin
        TEX_A10[k,i,j].Color16 := -1;
        Dec(i);
      end;
    end;

  for k := 0 to {2}0 do
    for i := 0 to A10_X-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      j := 0;
      while ((TEX_A10[k,i,j].Color16 = TransparantCol) OR (TEX_A10[k,i,j].Color16 = -1)) AND (j < A10_Y-1) do
      begin
        TEX_A10[k,i,j].Color16 := -1;
        Inc(j);
      end;
      j := A10_Y-1;
      while ((TEX_A10[k,i,j].Color16 = TransparantCol) OR (TEX_A10[k,i,j].Color16 = -1)) AND (j > 0) do
      begin
        TEX_A10[k,i,j].Color16 := -1;
        Dec(j);
      end;
    end;

  Assign(F, 'c:\gametex\flame33.raw');

  Reset(F);

  for k := 1 to {2}1 do
    for j := 0 to A10_Y-1 do
      for i := 0 to A10_X-1 do
      begin
        Read(F, Dat[0]);
        Read(F, Dat[1]);
        Read(F, Dat[2]);
{        TEXT_A10[k,i,j].R := Trunc(Dat[0]/86)*2*3+Trunc(Dat[1]/86)*2+Trunc(Dat[2]/128);}
        R := Trunc(Dat[0]/86);
        G := Trunc(Dat[1]/86);
        B := Trunc(Dat[2]/128);

        Color18 := R*3*2 + G*2 + B;

        TEX_A10[k,i,j].Color16 := Color18;

        case TEX_A10[k,i,j].Color16 of
          16 : TEX_A10[k,i,j].Color16 := 5;
          17 : TEX_A10[k,i,j].Color16 := 7;
        end;
      end;
  Close(F);

  TransparantCol := TEX_A10[1,0,0].Color16;  // note : upper-left pixel = transparancy color!!

  for k := 1 to {2}1 do
    for j := 0 to A10_Y-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      i := 0;
      while (TEX_A10[k,i,j].Color16 = TransparantCol) AND (i < A10_X-1) do
      begin
        TEX_A10[k,i,j].Color16 := -1;
        Inc(i);
      end;
      i := A10_X-1;
      while (TEX_A10[k,i,j].Color16 = TransparantCol) AND (i > 0) do
      begin
        TEX_A10[k,i,j].Color16 := -1;
        Dec(i);
      end;
    end;

  for k := 1 to {2}1 do
    for i := 0 to A10_X-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      j := 0;
      while ((TEX_A10[k,i,j].Color16 = TransparantCol) OR (TEX_A10[k,i,j].Color16 = -1)) AND (j < A10_Y-1) do
      begin
        TEX_A10[k,i,j].Color16 := -1;
        Inc(j);
      end;
      j := A10_Y-1;
      while ((TEX_A10[k,i,j].Color16 = TransparantCol) OR (TEX_A10[k,i,j].Color16 = -1)) AND (j > 0) do
      begin
        TEX_A10[k,i,j].Color16 := -1;
        Dec(j);
      end;
    end;

  Assign(F, 'c:\gametex\flame43.raw');

  Reset(F);

  for k := 2 to {2}2 do
    for j := 0 to A10_Y-1 do
      for i := 0 to A10_X-1 do
      begin
        Read(F, Dat[0]);
        Read(F, Dat[1]);
        Read(F, Dat[2]);
{        TEXT_A10[k,i,j].R := Trunc(Dat[0]/86)*2*3+Trunc(Dat[1]/86)*2+Trunc(Dat[2]/128);}
        R := Trunc(Dat[0]/86);
        G := Trunc(Dat[1]/86);
        B := Trunc(Dat[2]/128);

        Color18 := R*3*2 + G*2 + B;

        TEX_A10[k,i,j].Color16 := Color18;

        case TEX_A10[k,i,j].Color16 of
          16 : TEX_A10[k,i,j].Color16 := 5;
          17 : TEX_A10[k,i,j].Color16 := 7;
        end;
      end;
  Close(F);

  TransparantCol := TEX_A10[2,0,0].Color16;   // note : upper-left pixel = transparancy color!!

  for k := 2 to {2}2 do
    for j := 0 to A10_Y-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      i := 0;
      while (TEX_A10[k,i,j].Color16 = TransparantCol) AND (i < A10_X-1) do
      begin
        TEX_A10[k,i,j].Color16 := -1;
        Inc(i);
      end;
      i := A10_X-1;
      while (TEX_A10[k,i,j].Color16 = TransparantCol) AND (i > 0) do
      begin
        TEX_A10[k,i,j].Color16 := -1;
        Dec(i);
      end;
    end;

  for k := 2 to {2}2 do
    for i := 0 to A10_X-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      j := 0;
      while ((TEX_A10[k,i,j].Color16 = TransparantCol) OR (TEX_A10[k,i,j].Color16 = -1)) AND (j < A10_Y-1) do
      begin
        TEX_A10[k,i,j].Color16 := -1;
        Inc(j);
      end;
      j := A10_Y-1;
      while ((TEX_A10[k,i,j].Color16 = TransparantCol) OR (TEX_A10[k,i,j].Color16 = -1)) AND (j > 0) do
      begin
        TEX_A10[k,i,j].Color16 := -1;
        Dec(j);
      end;
    end;

  Assign(F, 'c:\gametex\walkbar1.raw');

  Reset(F);

  for k := 0 to {2}0 do
    for j := 0 to B10_Y-1 do
      for i := 0 to B10_X-1 do
      begin
        Read(F, Dat[0]);
        Read(F, Dat[1]);
        Read(F, Dat[2]);
{        TEXT_A10[k,i,j].R := Trunc(Dat[0]/86)*2*3+Trunc(Dat[1]/86)*2+Trunc(Dat[2]/128);}
        R := Trunc(Dat[0]/86);
        G := Trunc(Dat[1]/86);
        B := Trunc(Dat[2]/128);

        Color18 := R*3*2 + G*2 + B;

        TEX_B10[k,i,j].Color16 := Color18;

        case TEX_B10[k,i,j].Color16 of
          16 : TEX_B10[k,i,j].Color16 := 5;
          17 : TEX_B10[k,i,j].Color16 := 7;
        end;
      end;
  Close(F);

  TransparantCol := TEX_B10[0,0,0].Color16;  // note : upper-left pixel = transparancy color!!

  for k := 0 to {2}0 do
    for j := 0 to B10_Y-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      i := 0;
      while (TEX_B10[k,i,j].Color16 = TransparantCol) AND (i < B10_X-1) do
      begin
        TEX_B10[k,i,j].Color16 := -1;
        Inc(i);
      end;
      i := B10_X-1;
      while (TEX_B10[k,i,j].Color16 = TransparantCol) AND (i > 0) do
      begin
        TEX_B10[k,i,j].Color16 := -1;
        Dec(i);
      end;
    end;

  for k := 0 to {2}0 do
    for i := 0 to B10_X-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      j := 0;
      while ((TEX_B10[k,i,j].Color16 = TransparantCol) OR (TEX_B10[k,i,j].Color16 = -1)) AND (j < B10_Y-1) do
      begin
        TEX_B10[k,i,j].Color16 := -1;
        Inc(j);
      end;
      j := B10_Y-1;
      while ((TEX_B10[k,i,j].Color16 = TransparantCol) OR (TEX_B10[k,i,j].Color16 = -1)) AND (j > 0) do
      begin
        TEX_B10[k,i,j].Color16 := -1;
        Dec(j);
      end;
    end;
{ --- }

  Assign(F, 'c:\gametex\dollwlk1.raw');

  Reset(F);

  for k := 0 to {2}0 do
    for j := 0 to A20_Y-1 do
      for i := 0 to A20_X-1 do
      begin
        Read(F, Dat[0]);
        Read(F, Dat[1]);
        Read(F, Dat[2]);
{        TEXT_A10[k,i,j].R := Trunc(Dat[0]/86)*2*3+Trunc(Dat[1]/86)*2+Trunc(Dat[2]/128);}
        R := Trunc(Dat[0]/86);
        G := Trunc(Dat[1]/86);
        B := Trunc(Dat[2]/128);

        Color18 := R*3*2 + G*2 + B;

        TEX_A20[k,i,j].Color16 := Color18;

        case TEX_A20[k,i,j].Color16 of
          16 : TEX_A20[k,i,j].Color16 := 5;
          17 : TEX_A20[k,i,j].Color16 := 7;
        end;
      end;
  Close(F);

  TransparantCol := TEX_A20[0,0,0].Color16;  // note : upper-left pixel = transparancy color!!

  for k := 0 to {2}0 do
    for j := 0 to A20_Y-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      i := 0;
      while (TEX_A20[k,i,j].Color16 = TransparantCol) AND (i < A20_X-1) do
      begin
        TEX_A20[k,i,j].Color16 := -1;
        Inc(i);
      end;
      i := A20_X-1;
      while (TEX_A20[k,i,j].Color16 = TransparantCol) AND (i > 0) do
      begin
        TEX_A20[k,i,j].Color16 := -1;
        Dec(i);
      end;
    end;

  for k := 0 to {2}0 do
    for i := 0 to A20_X-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      j := 0;
      while ((TEX_A20[k,i,j].Color16 = TransparantCol) OR (TEX_A20[k,i,j].Color16 = -1)) AND (j < A20_Y-1) do
      begin
        TEX_A20[k,i,j].Color16 := -1;
        Inc(j);
      end;
      j := A20_Y-1;
      while ((TEX_A20[k,i,j].Color16 = TransparantCol) OR (TEX_A20[k,i,j].Color16 = -1)) AND (j > 0) do
      begin
        TEX_A20[k,i,j].Color16 := -1;
        Dec(j);
      end;
    end;

  Assign(F, 'c:\gametex\dollwlk2.raw');

  Reset(F);

  for k := 1 to {2}1 do
    for j := 0 to A20_Y-1 do
      for i := 0 to A20_X-1 do
      begin
        Read(F, Dat[0]);
        Read(F, Dat[1]);
        Read(F, Dat[2]);
{        TEXT_A20[k,i,j].R := Trunc(Dat[0]/86)*2*3+Trunc(Dat[1]/86)*2+Trunc(Dat[2]/128);}
        R := Trunc(Dat[0]/86);
        G := Trunc(Dat[1]/86);
        B := Trunc(Dat[2]/128);

        Color18 := R*3*2 + G*2 + B;

        TEX_A20[k,i,j].Color16 := Color18;

        case TEX_A20[k,i,j].Color16 of
          16 : TEX_A20[k,i,j].Color16 := 5;
          17 : TEX_A20[k,i,j].Color16 := 7;
        end;
      end;
  Close(F);

  TransparantCol := TEX_A20[1,0,0].Color16;  // note : upper-left pixel = transparancy color!!

  for k := 1 to {2}1 do
    for j := 0 to A20_Y-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      i := 0;
      while (TEX_A20[k,i,j].Color16 = TransparantCol) AND (i < A20_X-1) do
      begin
        TEX_A20[k,i,j].Color16 := -1;
        Inc(i);
      end;
      i := A20_X-1;
      while (TEX_A20[k,i,j].Color16 = TransparantCol) AND (i > 0) do
      begin
        TEX_A20[k,i,j].Color16 := -1;
        Dec(i);
      end;
    end;

  for k := 1 to {2}1 do
    for i := 0 to A20_X-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      j := 0;
      while ((TEX_A20[k,i,j].Color16 = TransparantCol) OR (TEX_A20[k,i,j].Color16 = -1)) AND (j < A20_Y-1) do
      begin
        TEX_A20[k,i,j].Color16 := -1;
        Inc(j);
      end;
      j := A20_Y-1;
      while ((TEX_A20[k,i,j].Color16 = TransparantCol) OR (TEX_A20[k,i,j].Color16 = -1)) AND (j > 0) do
      begin
        TEX_A20[k,i,j].Color16 := -1;
        Dec(j);
      end;
    end;

  Assign(F, 'c:\gametex\dollwlk3.raw');

  Reset(F);

  for k := 2 to {2}2 do
    for j := 0 to A20_Y-1 do
      for i := 0 to A20_X-1 do
      begin
        Read(F, Dat[0]);
        Read(F, Dat[1]);
        Read(F, Dat[2]);
{        TEXT_A20[k,i,j].R := Trunc(Dat[0]/86)*2*3+Trunc(Dat[1]/86)*2+Trunc(Dat[2]/128);}
        R := Trunc(Dat[0]/86);
        G := Trunc(Dat[1]/86);
        B := Trunc(Dat[2]/128);

        Color18 := R*3*2 + G*2 + B;

        TEX_A20[k,i,j].Color16 := Color18;

        case TEX_A20[k,i,j].Color16 of
          16 : TEX_A20[k,i,j].Color16 := 5;
          17 : TEX_A20[k,i,j].Color16 := 7;
        end;
      end;
  Close(F);

  TransparantCol := TEX_A20[2,0,0].Color16;   // note : upper-left pixel = transparancy color!!

  for k := 2 to {2}2 do
    for j := 0 to A20_Y-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      i := 0;
      while (TEX_A20[k,i,j].Color16 = TransparantCol) AND (i < A20_X-1) do
      begin
        TEX_A20[k,i,j].Color16 := -1;
        Inc(i);
      end;
      i := A20_X-1;
      while (TEX_A20[k,i,j].Color16 = TransparantCol) AND (i > 0) do
      begin
        TEX_A20[k,i,j].Color16 := -1;
        Dec(i);
      end;
    end;

  for k := 2 to {2}2 do
    for i := 0 to A20_X-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      j := 0;
      while ((TEX_A20[k,i,j].Color16 = TransparantCol) OR (TEX_A20[k,i,j].Color16 = -1)) AND (j < A20_Y-1) do
      begin
        TEX_A20[k,i,j].Color16 := -1;
        Inc(j);
      end;
      j := A20_Y-1;
      while ((TEX_A20[k,i,j].Color16 = TransparantCol) OR (TEX_A20[k,i,j].Color16 = -1)) AND (j > 0) do
      begin
        TEX_A20[k,i,j].Color16 := -1;
        Dec(j);
      end;
    end;

{ --- }

  Assign(F, 'c:\gametex\ball101.raw');

  Reset(F);

  for k := 0 to {2}0 do
    for j := 0 to C30_Y-1 do
      for i := 0 to C30_X-1 do
      begin
        Read(F, Dat[0]);
        Read(F, Dat[1]);
        Read(F, Dat[2]);
{        TEXT_A10[k,i,j].R := Trunc(Dat[0]/86)*2*3+Trunc(Dat[1]/86)*2+Trunc(Dat[2]/128);}
        R := Trunc(Dat[0]/86);
        G := Trunc(Dat[1]/86);
        B := Trunc(Dat[2]/128);

        Color18 := R*3*2 + G*2 + B;

        TEX_C30[k,i,j].Color16 := Color18;

        case TEX_C30[k,i,j].Color16 of
          16 : TEX_C30[k,i,j].Color16 := 5;
          17 : TEX_C30[k,i,j].Color16 := 7;
        end;
      end;
  Close(F);

  TransparantCol := TEX_C30[0,0,0].Color16;  // note : upper-left pixel = transparancy color!!

  for k := 0 to {2}0 do
    for j := 0 to C30_Y-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      i := 0;
      while (TEX_C30[k,i,j].Color16 = TransparantCol) AND (i < A20_X-1) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Inc(i);
      end;
      i := C30_X-1;
      while (TEX_C30[k,i,j].Color16 = TransparantCol) AND (i > 0) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Dec(i);
      end;
    end;

  for k := 0 to {2}0 do
    for i := 0 to C30_X-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      j := 0;
      while ((TEX_C30[k,i,j].Color16 = TransparantCol) OR (TEX_C30[k,i,j].Color16 = -1)) AND (j < A20_Y-1) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Inc(j);
      end;
      j := C30_Y-1;
      while ((TEX_C30[k,i,j].Color16 = TransparantCol) OR (TEX_C30[k,i,j].Color16 = -1)) AND (j > 0) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Dec(j);
      end;
    end;

  Assign(F, 'c:\gametex\ball102.raw');

  Reset(F);

  for k := 1 to {2}1 do
    for j := 0 to C30_Y-1 do
      for i := 0 to C30_X-1 do
      begin
        Read(F, Dat[0]);
        Read(F, Dat[1]);
        Read(F, Dat[2]);
{        TEXT_A10[k,i,j].R := Trunc(Dat[0]/86)*2*3+Trunc(Dat[1]/86)*2+Trunc(Dat[2]/128);}
        R := Trunc(Dat[0]/86);
        G := Trunc(Dat[1]/86);
        B := Trunc(Dat[2]/128);

        Color18 := R*3*2 + G*2 + B;

        TEX_C30[k,i,j].Color16 := Color18;

        case TEX_C30[k,i,j].Color16 of
          16 : TEX_C30[k,i,j].Color16 := 5;
          17 : TEX_C30[k,i,j].Color16 := 7;
        end;
      end;
  Close(F);

  TransparantCol := TEX_C30[1,0,0].Color16;  // note : upper-left pixel = transparancy color!!

  for k := 1 to {2}1 do
    for j := 0 to C30_Y-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      i := 0;
      while (TEX_C30[k,i,j].Color16 = TransparantCol) AND (i < A20_X-1) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Inc(i);
      end;
      i := C30_X-1;
      while (TEX_C30[k,i,j].Color16 = TransparantCol) AND (i > 0) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Dec(i);
      end;
    end;

  for k := 1 to {2}1 do
    for i := 0 to C30_X-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      j := 0;
      while ((TEX_C30[k,i,j].Color16 = TransparantCol) OR (TEX_C30[k,i,j].Color16 = -1)) AND (j < A20_Y-1) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Inc(j);
      end;
      j := C30_Y-1;
      while ((TEX_C30[k,i,j].Color16 = TransparantCol) OR (TEX_C30[k,i,j].Color16 = -1)) AND (j > 0) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Dec(j);
      end;
    end;

  Assign(F, 'c:\gametex\ball103.raw');

  Reset(F);

  for k := 2 to {2}2 do
    for j := 0 to C30_Y-1 do
      for i := 0 to C30_X-1 do
      begin
        Read(F, Dat[0]);
        Read(F, Dat[1]);
        Read(F, Dat[2]);
{        TEXT_A10[k,i,j].R := Trunc(Dat[0]/86)*2*3+Trunc(Dat[1]/86)*2+Trunc(Dat[2]/128);}
        R := Trunc(Dat[0]/86);
        G := Trunc(Dat[1]/86);
        B := Trunc(Dat[2]/128);

        Color18 := R*3*2 + G*2 + B;

        TEX_C30[k,i,j].Color16 := Color18;

        case TEX_C30[k,i,j].Color16 of
          16 : TEX_C30[k,i,j].Color16 := 5;
          17 : TEX_C30[k,i,j].Color16 := 7;
        end;
      end;
  Close(F);

  TransparantCol := TEX_C30[2,0,0].Color16;  // note : upper-left pixel = transparancy color!!

  for k := 2 to {2}2 do
    for j := 0 to C30_Y-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      i := 0;
      while (TEX_C30[k,i,j].Color16 = TransparantCol) AND (i < A20_X-1) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Inc(i);
      end;
      i := C30_X-1;
      while (TEX_C30[k,i,j].Color16 = TransparantCol) AND (i > 0) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Dec(i);
      end;
    end;

  for k := 2 to {2}2 do
    for i := 0 to C30_X-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      j := 0;
      while ((TEX_C30[k,i,j].Color16 = TransparantCol) OR (TEX_C30[k,i,j].Color16 = -1)) AND (j < A20_Y-1) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Inc(j);
      end;
      j := C30_Y-1;
      while ((TEX_C30[k,i,j].Color16 = TransparantCol) OR (TEX_C30[k,i,j].Color16 = -1)) AND (j > 0) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Dec(j);
      end;
    end;

  Assign(F, 'c:\gametex\ball104.raw');

  Reset(F);

  for k := 3 to {2}3 do
    for j := 0 to C30_Y-1 do
      for i := 0 to C30_X-1 do
      begin
        Read(F, Dat[0]);
        Read(F, Dat[1]);
        Read(F, Dat[2]);
{        TEXT_A10[k,i,j].R := Trunc(Dat[0]/86)*2*3+Trunc(Dat[1]/86)*2+Trunc(Dat[2]/128);}
        R := Trunc(Dat[0]/86);
        G := Trunc(Dat[1]/86);
        B := Trunc(Dat[2]/128);

        Color18 := R*3*2 + G*2 + B;

        TEX_C30[k,i,j].Color16 := Color18;

        case TEX_C30[k,i,j].Color16 of
          16 : TEX_C30[k,i,j].Color16 := 5;
          17 : TEX_C30[k,i,j].Color16 := 7;
        end;
      end;
  Close(F);

  TransparantCol := TEX_C30[3,0,0].Color16;  // note : upper-left pixel = transparancy color!!

  for k := 3 to {2}3 do
    for j := 0 to C30_Y-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      i := 0;
      while (TEX_C30[k,i,j].Color16 = TransparantCol) AND (i < A20_X-1) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Inc(i);
      end;
      i := C30_X-1;
      while (TEX_C30[k,i,j].Color16 = TransparantCol) AND (i > 0) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Dec(i);
      end;
    end;

  for k := 3 to {2}3 do
    for i := 0 to C30_X-1 do
    begin
{      if TEX_B10[k,i,j].Color16 = TransparantCol then}
      j := 0;
      while ((TEX_C30[k,i,j].Color16 = TransparantCol) OR (TEX_C30[k,i,j].Color16 = -1)) AND (j < A20_Y-1) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Inc(j);
      end;
      j := C30_Y-1;
      while ((TEX_C30[k,i,j].Color16 = TransparantCol) OR (TEX_C30[k,i,j].Color16 = -1)) AND (j > 0) do
      begin
        TEX_C30[k,i,j].Color16 := -1;
        Dec(j);
      end;
    end;

{ --- }

end;

begin

end.
