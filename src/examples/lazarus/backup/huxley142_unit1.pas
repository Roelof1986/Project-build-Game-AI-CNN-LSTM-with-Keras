unit Huxley142_unit1;

// Huxley142_unit1 : Code of the 2D game 'Heroic Huxley' written by Roelof Emmerink (rpe86@hotmail.com)
// This game makes use of Allegro (see Allegro5.pas)

{$mode ObjFPC}{$H+}

interface

uses Crt, {evBGIDr,} {Graph,} Dos, Textur95, Allegro5, al5base, al5image, al5strings, Bitmaps_unit2;

const
      MaxBars = 24;
      MaxFires = 16;
      MaxBalls = 8;

      GetMaxX = {639}639;
      GetMaxY = {349}479;

      PlC_Gravity = {16}3; // valid values are -16 .. 16

      LowerPlC_ClampX = {1.0}{2.0}1.5; // valid values are 0.5 .. 2.5
      UpperPlC_ClampX = 1.5;

      LowerPlC_ClampY = 2.5; // valid values are 0.5 .. 2.5
      UpperPlC_ClampY = 1.5;

      CollisionThicknessX = {3}3; // valid values are 1 .. 6

      CollisionThicknessY = {3}3; // valid values are 1 .. 6

      CollisionVelocityX = {8}1; // valid values are 1 .. 8

      CollisionVelocityY = {8}1; // valid values are 1 .. 8 --> must be higher when gravity is higher

      SlowDownX = 0.1; // slow down after collision. valid values are 0.1 .. 0.5

      SlowDownY = 0.1;

var
    i, j, k : Integer;

{    Driver, Mode : Integer;}

    Cycles : Longint;

    PicCycles, PicCycles2 : Integer;

    Page : Word;

    TransparantCol : Integer;

    PlC : record
            X, Y, PX, PY, VPX, VPY, VPX2, VPY2, SpdRec, PSX, SX, PSY, SY : Integer;
            ReverseD, WalkRight, WalkLeft, Jump, CancelJump : Boolean;
            JumpTime : Byte;
            PicView : Byte;
            PicCycles : Longint;
          end;

    WlkB : array[0..{5}MaxBars-1] of record
                            X, Y : Integer;
                          end;

    Fire : array[0..{5}MaxFires-1] of record
                            X, Y : Integer;
                            PicView : Byte;
                            PicCycles : Longint;
                          end;

    Ball : array[0..{5}MaxBalls-1] of record
                            X, Y, PX, PY, PX2, PY2,
                            XTraject_lo, XTraject_hi : Integer;
                            PicView : Byte;
                            PicCycles : Longint;
                            ReverseD : Boolean;
                            RevTimer : Word;
                            Sleep : Boolean;
                            SleepTimer : Word;
                            SeesPlayer : Boolean;
                          end;

    CollisionMatrixA, CollisionMatrixB : array[0..119,0..119] of Shortint;

    PlayerCollision : Boolean;

    Xco, Yco : Integer;

    SubCycles : Integer;

    C : Char;

    ArrP : Byte;

    Xcollision, Ycollision, Xcheck, Ycheck : Boolean;

    DistClosestObj : SINGLE;

    ClosestObj : Longint;

    ArrR, ArrL, CTRL, ALT, Esc : Byte;

    ScanCode : Byte;

    StrOut : string;

    It : Longint;

    JumpCollision : Boolean;

    TmHr, TmMn, TmSc, TmS100, TmS100_2 : Word;

    Gd, Gm : Integer;

    RowCollision, CollumnCollision : Boolean;

    TotalRowsColl, TotalCollumnsColl : Longint;

    Yup, Xlft : Boolean;

    SFreq : Word;

    NrOfBars, NrOfFires, NrOfBalls : Word;

    ScanCode2 : Longint;

    X0, X1, Y0, Y1 : Longint;

    XWnd : Longint;

    {Refresh, pRefresh,} WaitAndRefresh, DontClear : Boolean;

    Refresh : Word;

    SurfaceContact : Boolean;

    TSurfaceContact : Word;

    CollisionOnhold : Word;

    PxlColor : array[0..15] of ALLEGRO_COLOR;

    UpperY, LowerY, UpperX, LowerX : Longint;

    // ---

(*    FileName: AL_STR;
    Bitmap_FL23, Bitmap_FL33, Bitmap_FL43,
    Bitmap_WB1,
    Bitmap_DW1, Bitmap_DW2, Bitmap_DW3,
    Bitmap_B101, Bitmap_B102, Bitmap_B103, Bitmap_B104 : ALLEGRO_BITMAPptr; *)

procedure InitHuxley;

procedure ProcessPhysics;

implementation

procedure InitHuxley;

begin

  PlC.X := {100}60;
  PlC.Y := (GetMaxY-9)-100;

  NrOfBars := {8}15;

  WlkB[0].X := 0;
  WlkB[0].Y := GetMaxY-9;

  WlkB[1].X := 80;
  WlkB[1].Y := GetMaxY-9;

  WlkB[2].X := 80*2;
  WlkB[2].Y := GetMaxY-9;

  WlkB[3].X := 80*4;
  WlkB[3].Y := GetMaxY-9;

  WlkB[4].X := 80*5;
  WlkB[4].Y := GetMaxY-69;

  WlkB[5].X := 80*6;
  WlkB[5].Y := GetMaxY-69;

  WlkB[6].X := 80*3;
  WlkB[6].Y := GetMaxY-139;

  WlkB[7].X := 80*2;
  WlkB[7].Y := GetMaxY-139;

  WlkB[8].X := 80*6;
  WlkB[8].Y := GetMaxY-169;

  WlkB[9].X := 80*7;
  WlkB[9].Y := GetMaxY-169;

  WlkB[10].X := 80*8;
  WlkB[10].Y := GetMaxY-169;

  WlkB[11].X := 80*9;
  WlkB[11].Y := GetMaxY-169;

  WlkB[12].X := 80*9;
  WlkB[12].Y := GetMaxY-9;

  WlkB[13].X := 80*10;
  WlkB[13].Y := GetMaxY-9;

  WlkB[14].X := 80*11;
  WlkB[14].Y := GetMaxY-9;

  NrOfFires := 4;

  Fire[0].X := 80*2-24;
  Fire[0].Y := GetMaxY-159;

  Fire[1].X := 80*2-8;
  Fire[1].Y := GetMaxY-159;

  Fire[2].X := 80*2+8;
  Fire[2].Y := GetMaxY-159;

  Fire[3].X := 80*2+24;
  Fire[3].Y := GetMaxY-159;

  NrOfBalls := 1;

  Ball[0].X := 80*6;
  Ball[0].Y := GetMaxY-192;

  Ball[0].XTraject_lo := 80*6-32;
  Ball[0].XTraject_hi := 80*7+32;

  XWnd := 0;

  { --- }

  for i := 0 to 17 do
  begin
    if i < 16 then
    begin
      Color.R := i DIV (3*2);
      Color.G := (i MOD (3*2)) DIV (2);
      Color.B := i MOD 2;
//      SetRGBPalette(i, Color.R*127, Color.G*127, Color.B*255);
      PxlColor[i].R := Color.R;
      PxlColor[i].G := Color.G;
      PxlColor[i].B := Color.B;
      PxlColor[i].A := 255;
    end
    else
    begin
      Color.R := i DIV (3*2);
      Color.G := (i MOD (3*2)) DIV (2);
      Color.B := i MOD 2;
      case i of
        16 : {SetRGBPalette(5, Color.R*127, Color.G*127, Color.B*255)}
              begin
                PxlColor[{i}5].R := Color.R;
                PxlColor[{i}5].G := Color.G;
                PxlColor[{i}5].B := Color.B;
                PxlColor[{i}5].A := 255;
              end;
        17 : {SetRGBPalette(7, Color.R*127, Color.G*127, Color.B*255)}
              begin
                PxlColor[{i}7].R := Color.R;
                PxlColor[{i}7].G := Color.G;
                PxlColor[{i}7].B := Color.B;
                PxlColor[{i}7].A := 255;
              end;
      end;
    end;
   end;

  InitTextures;

{ --- }


(*  FileName := 'c:\GAMETEX\FLAME23.png';

  Bitmap_FL23 := al_load_bitmap (FileName);*)

(*  FileName := 'c:\GAMETEX\FLAME33.png';

  Bitmap_FL33 := al_load_bitmap (FileName);

  FileName := 'c:\GAMETEX\FLAME43.png';

  Bitmap_FL43 := al_load_bitmap (FileName);

  FileName := 'c:\GAMETEX\WALKBAR1.png';

  Bitmap_WB1 := al_load_bitmap (FileName);

  FileName := 'c:\GAMETEX\DOLLWLK1.png';

  Bitmap_DW1 := al_load_bitmap (FileName);

  FileName := 'c:\GAMETEX\DOLLWLK2.png';

  Bitmap_DW2 := al_load_bitmap (FileName);

  FileName := 'c:\GAMETEX\DOLLWLK3.png';

  Bitmap_DW3 := al_load_bitmap (FileName);

  FileName := 'c:\GAMETEX\BALL101.png';

  Bitmap_B101 := al_load_bitmap (FileName);

  FileName := 'c:\GAMETEX\BALL102.png';

  Bitmap_B102 := al_load_bitmap (FileName);

  FileName := 'c:\GAMETEX\BALL103.png';

  Bitmap_B103 := al_load_bitmap (FileName);

  FileName := 'c:\GAMETEX\BALL104.png';

  Bitmap_B104 := al_load_bitmap (FileName);  *)

//  Readln;

(*  for j := 0 to B10_Y-1 do
    for i := 0 to B10_X-1 do
      if TEX_B10[0,i,j].Color16 <> -1 then
        PutPixel(100+i, 100+j, TEX_B10[0,i,j].Color16);

  Readln; *)

(*  for Cycles := 0 to {80}{120}{240}{80}240 do
  begin*)

  {pRefresh := True;}
  Refresh := {True}2;

end;

procedure DrawPixels_1;

begin

//  if {pRefresh}Refresh > 0 then
  for k := 0 to (NrOfBars-1) do
  begin

    X0 := WlkB[k].X;
    X1 := PlC.X;
    Y0 := WlkB[k].Y;
    Y1 := PlC.Y;

//  if (Sqrt(Abs(Sqr(X0-X1)+Sqr(Y0-Y1))+1E-1) < {40}{165}95) OR (NOT DontClear) then {!!!}
(*  for j := 0 to B10_Y-1 do
    for i := 0 to B10_X-1 do
      if TEX_B10[0,i,j].Color16 <> -1 then
//        PutPixel(XWnd+i+WlkB[k].X-(B10_X DIV 2), j+WlkB[k].Y-(B10_Y DIV 2), TEX_B10[0,i,j].Color16);
        al_put_pixel(XWnd+i+WlkB[k].X-(B10_X DIV 2), j+WlkB[k].Y-(B10_Y DIV 2), PxlColor[TEX_B10[0,i,j].Color16]); *)
//  if (XWnd+WlkB[k].X-(B10_X DIV 2) < GetMaxX) AND (WlkB[k].Y-(B10_Y DIV 2) < GetMaxY) then
    al_draw_bitmap(Bitmap_WB1, XWnd+WlkB[k].X-(B10_X DIV 2), WlkB[k].Y-(B10_Y DIV 2), 0);

  end;

  for k := 0 to (NrOfFires-1) do
(*  for j := 0 to A10_Y-1 do
    for i := 0 to A10_X-1 do
      if TEX_A10[Fire[k].PicView,i,j].Color16 <> -1 then
//        PutPixel(XWnd+i+Fire[k].X-(A10_X DIV 2), j+Fire[k].Y-(A10_Y DIV 2), TEX_A10[Fire[k].PicView,i,j].Color16)
        al_put_pixel(XWnd+i+Fire[k].X-(A10_X DIV 2), j+Fire[k].Y-(A10_Y DIV 2), PxlColor[TEX_A10[Fire[k].PicView,i,j].Color16])
      else
//        PutPixel(XWnd+i+Fire[k].X-(A10_X DIV 2), j+Fire[k].Y-(A10_Y DIV 2), 0);
        al_put_pixel(XWnd+i+Fire[k].X-(A10_X DIV 2), j+Fire[k].Y-(A10_Y DIV 2), PxlColor[0]);*)

   case Fire[k].PicView of

     0: al_draw_bitmap(Bitmap_FL23, XWnd+Fire[k].X-(A10_X DIV 2), Fire[k].Y-(A10_Y DIV 2), 0);
     1: al_draw_bitmap(Bitmap_FL33, XWnd+Fire[k].X-(A10_X DIV 2), Fire[k].Y-(A10_Y DIV 2), 0);
     2: al_draw_bitmap(Bitmap_FL43, XWnd+Fire[k].X-(A10_X DIV 2), Fire[k].Y-(A10_Y DIV 2), 0);

   end;

  { ---- }

  for k := 0 to (NrOfBalls-1) do
  begin

(*...  for j := 0 to C30_Y-1 do
    for i := 0 to C30_X-1 do
    if {(i <= Ball[k].PX2-Ball[k].X)} (i >= Ball[k].X-Ball[k].PX2) then
//      PutPixel(XWnd+-i+Ball[k].PX2+(C30_X DIV 2)-1, j+Ball[k].PY2-(C30_Y DIV 2), 0);
      al_put_pixel(XWnd+-i+Ball[k].PX2+(C30_X DIV 2)-1, j+Ball[k].PY2-(C30_Y DIV 2), PxlColor[0]); ...*) // note : turn on w/ input pixels!

(*  for j := 0 to C30_Y-1 do
    for i := 0 to C30_X-1 do
      PutPixel(XWnd+-i+Ball[k].PX+(C30_X DIV 2)-1, j+Ball[k].PY-(C30_Y DIV 2), 0); *)

  if NOT Ball[k].ReverseD then
    case Ball[k].PicView of

      0: al_draw_bitmap(Bitmap_B101, (XWnd+Ball[k].X-(C30_X DIV 2)), Ball[k].Y-(C30_Y DIV 2), ALLEGRO_FLIP_HORIZONTAL);
      1: al_draw_bitmap(Bitmap_B102, (XWnd+Ball[k].X-(C30_X DIV 2)), Ball[k].Y-(C30_Y DIV 2), ALLEGRO_FLIP_HORIZONTAL);
      2: al_draw_bitmap(Bitmap_B103, (XWnd+Ball[k].X-(C30_X DIV 2)), Ball[k].Y-(C30_Y DIV 2), ALLEGRO_FLIP_HORIZONTAL);
      3: al_draw_bitmap(Bitmap_B104, (XWnd+Ball[k].X-(C30_X DIV 2)), Ball[k].Y-(C30_Y DIV 2), ALLEGRO_FLIP_HORIZONTAL);

    end
  else
    case Ball[k].PicView of

      0: al_draw_bitmap(Bitmap_B101, (XWnd+Ball[k].X-(C30_X DIV 2)), Ball[k].Y-(C30_Y DIV 2), 0);
      1: al_draw_bitmap(Bitmap_B102, (XWnd+Ball[k].X-(C30_X DIV 2)), Ball[k].Y-(C30_Y DIV 2), 0);
      2: al_draw_bitmap(Bitmap_B103, (XWnd+Ball[k].X-(C30_X DIV 2)), Ball[k].Y-(C30_Y DIV 2), 0);
      3: al_draw_bitmap(Bitmap_B104, (XWnd+Ball[k].X-(C30_X DIV 2)), Ball[k].Y-(C30_Y DIV 2), 0);

    end;

(*...  for j := 0 to C30_Y-1 do
    for i := 0 to C30_X-1 do
    begin
      if NOT Ball[k].ReverseD then
      begin
        if TEX_C30[Ball[k].PicView,i,j].Color16 <> -1 then
//          PutPixel(XWnd+-i+Ball[k].X+(C30_X DIV 2)-1, j+Ball[k].Y-(C30_Y DIV 2), TEX_C30[Ball[k].PicView,i,j].Color16)
          al_put_pixel(XWnd+-i+Ball[k].X+(C30_X DIV 2)-1, j+Ball[k].Y-(C30_Y DIV 2), PxlColor[TEX_C30[Ball[k].PicView,i,j].Color16])
        else
//          PutPixel(XWnd+-i+Ball[k].X+(C30_X DIV 2)-1, j+Ball[k].Y-(C30_Y DIV 2), 0);
          al_put_pixel(XWnd+-i+Ball[k].X+(C30_X DIV 2)-1, j+Ball[k].Y-(C30_Y DIV 2), PxlColor[0]);
      end
      else
      begin
        if TEX_C30[Ball[k].PicView,i,j].Color16 <> -1 then
//          PutPixel(XWnd+i+Ball[k].X-(C30_X DIV 2), j+Ball[k].Y-(C30_Y DIV 2), TEX_C30[Ball[k].PicView,i,j].Color16)
          al_put_pixel(XWnd+i+Ball[k].X-(C30_X DIV 2), j+Ball[k].Y-(C30_Y DIV 2), PxlColor[TEX_C30[Ball[k].PicView,i,j].Color16])
        else
//          PutPixel(XWnd+{-}i+Ball[k].X{+}-(C30_X DIV 2){-1}, j+Ball[k].Y-(C30_Y DIV 2), 0);
          al_put_pixel(XWnd+{-}i+Ball[k].X{+}-(C30_X DIV 2){-1}, j+Ball[k].Y-(C30_Y DIV 2), PxlColor[0])
      end;             {// above : debug. (+i insteadof -i)}
    end; *)
  end;

end;

procedure DrawPixels_2;

begin

(*  for j := 0 to A20_Y-1 do
    for i := 0 to A20_X-1 do
(*    if {(i <= Ball[k].PX2-Ball[k].X)} (i >= PlC.X-PlC.VPX2) then*)
//      PutPixel(XWnd+-i+PlC.VPX2+(A20_X DIV 2)-1, j+PlC.VPY2-(A20_Y DIV 2), 0);
      al_put_pixel(XWnd+-i+PlC.VPX2+(A20_X DIV 2)-1, j+PlC.VPY2-(A20_Y DIV 2), PxlColor[0]); *)

  if NOT PlC.ReverseD then
    case PlC.PicView of

      0: al_draw_bitmap(Bitmap_DW1, (XWnd+PlC.X-(A20_X DIV 2)), PlC.Y-(A20_Y DIV 2), 0);
      1: al_draw_bitmap(Bitmap_DW2, (XWnd+PlC.X-(A20_X DIV 2)), PlC.Y-(A20_Y DIV 2), 0);
      2: al_draw_bitmap(Bitmap_DW3, (XWnd+PlC.X-(A20_X DIV 2)), PlC.Y-(A20_Y DIV 2), 0);

    end
  else
    case PlC.PicView of

      0: al_draw_bitmap(Bitmap_DW1, (XWnd+PlC.X-(A20_X DIV 2)), PlC.Y-(A20_Y DIV 2), ALLEGRO_FLIP_HORIZONTAL);
      1: al_draw_bitmap(Bitmap_DW2, (XWnd+PlC.X-(A20_X DIV 2)), PlC.Y-(A20_Y DIV 2), ALLEGRO_FLIP_HORIZONTAL);
      2: al_draw_bitmap(Bitmap_DW3, (XWnd+PlC.X-(A20_X DIV 2)), PlC.Y-(A20_Y DIV 2), ALLEGRO_FLIP_HORIZONTAL);

    end;

//  al_draw_bitmap(Bitmap_DW1, XWnd+60+(A20_X DIV 2)-1, (GetMaxY-100)-(A20_Y DIV 2), 0)

(*...  for j := 0 to A20_Y-1 do
    for i := 0 to A20_X-1 do
    begin
      if PlC.ReverseD then
      begin
        if TEX_A20[PlC.PicView,i,j].Color16 <> -1 then
//          PutPixel(XWnd+-i+PlC.X+(A20_X DIV 2)-1, j+PlC.Y-(A20_Y DIV 2), TEX_A20[PlC.PicView,i,j].Color16)
          al_put_pixel(XWnd+-i+PlC.X+(A20_X DIV 2)-1, j+PlC.Y-(A20_Y DIV 2), PxlColor[TEX_A20[PlC.PicView,i,j].Color16])
(*        else
          PutPixel(XWnd+-i+PlC.X+(A20_X DIV 2)-1, j+PlC.Y-(A20_Y DIV 2), 0)*);
      end
      else
      begin
        if TEX_A20[PlC.PicView,i,j].Color16 <> -1 then
//          PutPixel(XWnd+i+PlC.X-(A20_X DIV 2), j+PlC.Y-(A20_Y DIV 2), TEX_A20[PlC.PicView,i,j].Color16)
          al_put_pixel(XWnd+i+PlC.X-(A20_X DIV 2), j+PlC.Y-(A20_Y DIV 2), PxlColor[TEX_A20[PlC.PicView,i,j].Color16])
(*        else
          PutPixel(XWnd+i+PlC.X-(A20_X DIV 2), j+PlC.Y-(A20_Y DIV 2), 0)*);
      end;
    end; *)

end;

procedure ProcessPhysics;

begin

//.  repeat

  Inc(Cycles);

  if Cycles > 1000000000 then
    Cycles := 0;

{  C := Chr(255);}

(*   if KeyPressed then
     while KeyPressed do
       C := ReadKey
   else
     C := Chr(0); *)

(*  if KeyPressed then
    C := ReadKey;

  if C = Chr(0) then
    C := ReadKey; *)

(*  repeat
    C := Readkey;
  until C <> Chr(0); *)

{  SetVisualPage(Page);}
(*  Delay({25}{83}{100}{83}{33}9{250});*)

  It := 0;

{  GetTime(TmHr, TmMn, TmSc, TmS100);}

{    CheckKeys;}

{  NoSound;}

(*.  repeat

{    if PlC.JumpTime < 15 then}
(*      SFreq := PlC.JumpTime*40;*)

    if (PlC.JumpTime > 0) then
    begin
      if (PlC.JumpTime < 15) then
      begin
{      Sound(Round(Exp(Ln((SFreq MOD 12)/12)/Ln(2))*Ln(2)*10));}
{       Sound(Round(1000*(SFreq MOD 12)/12))}
{      Sound(((100+SFreq) MOD 800)*20);}
        SFreq := PlC.JumpTime*40;
        Sound(Random((SFreq))+100*PlC.JumpTime);
      end
      else
      begin
        SFreq := PlC.JumpTime*40;
        Sound(Random((SFreq))+{100*6}82);
      end;
    end
    else
    begin

    SFreq := PlC.PicView*40;

    if PlC.WalkLeft OR PlC.WalkRight then
    begin
      Sound(Random((SFreq))+100*PlC.PicView);
    end;

    end;

{    CheckKeys;}

{.    Keyb96Check;}

    Inc(It);
    Delay(2);
{    GetTime(TmHr, TmMn, TmSc, TmS100_2);}

{    NoSound;}

{    Delay(2);}
  until (It >= {50}{38}{150}{10}1) (*AND ((TmS100_2-TmS100) >= {8}{2}{20}2)*); .*)

{.  NoSound;}

{  ClearKeyboardBuffer;}

{.  Page := NOT Page;
  SetActivePage(Page);}

{   ClearViewport;}

(*  if NOT DontClear then
  if Refresh > 0 then
    ClearDevice; .*)

{  SetBkColor(0);}
{  Bar(0, 0, 320, 200);}
{  ClearViewport;}

(*  Str(GetMaxY, StrOut);

  OutTextXY(150, 150, StrOut); *)

{  SetFillStyle(0, 0);

  Bar(0, 0, 639, 349);}

{  SetColor(10);
  Bar(0, 50, 200, 500);}

{  NoSound;}

 DrawPixels_1;
// DrawPixels_2;

{  NoSound;}

  {pRefresh := Refresh;}

  {Refresh := False;}
  if Refresh > 0 then
    Dec(Refresh)
  else
    DontClear := False;

  { ---- }

{  SetBkColor(7);}

  Inc(PlC.PicCycles) {:= Cycles MOD 4};

  if PlC.PicCycles MOD 4 < 3 then {debug!! PlC. instead of without}
    PlC.PicView := PlC.PicCycles MOD 4
  else
    PlC.PicView := 1;

{  if (ArrP = 0) then}
  if {(ArrR = 0)}(NOT PlC.WalkRight) AND (NOT PlC.WalkLeft) then
  begin
    PlC.PicView := 1;
    PlC.PicCycles := 0;
  end;

{  if (ArrP = 3) then}
{  if (ArrP = 3) then}
  if PlC.Jump then
    PlC.PicView := 2;

  for k := 0 to NrOfFires-1 do
  begin
    Inc(Fire[k].PicCycles){2} {:= Cycles MOD 3};

    if Fire[k].PicCycles > 1000000000 then
      Fire[k].PicCycles := 0;

    Fire[k].PicView := (Fire[k].PicCycles{2}+(k MOD 2)) MOD 3;
  end;

{  PicCycles2 := Cycles MOD 3;}

{  Ball[0].PicView := 0;}
  for k := 0 to NrOfBalls-1 do
  begin
    Inc(Ball[k].PicCycles);

    if Ball[k].Sleep then
    begin
      Ball[k].PicView := 0;
      Ball[k].PicCycles := 0;
    end
    else
      Ball[k].PicView := (Ball[k].PicCycles MOD 3)+1;
  end;


{  Ball[0].ReverseD := True;}

  {Below Non-player character movement}

  Ball[k].PX2 := Ball[k].PX;
  Ball[k].PY2 := Ball[k].PY;

  Ball[k].PX := Ball[k].X;
  Ball[k].PY := Ball[k].Y;

  for k := 0 to NrOfBalls-1 do
  begin

    if NOT Ball[k].Sleep then
      if Ball[k].ReverseD then
        Dec(Ball[k].X, 8)
      else
        Inc(Ball[k].X, 8);

    X0 := Ball[k].X;
    X1 := PlC.X;
    Y0 := Ball[k].Y;
    Y1 := PlC.Y;

    if Sqrt(Abs(Sqr(X0-X1)+Sqr(Y0-Y1))+1E-1) < 120 then
      Ball[k].SeesPlayer := True
    else
      Ball[k].SeesPlayer := False;

    if ((Random({10}10) = 0) OR Ball[k].SeesPlayer) AND (Ball[k].RevTimer = 0) AND (NOT Ball[k].Sleep) then
    begin

      {below : attack player}

      if Ball[k].SeesPlayer then
      begin

        if PlC.X > Ball[k].X then
          Ball[k].ReverseD := False
        else
          Ball[k].ReverseD := True;

        Ball[k].RevTimer := 5;

      end
      else
      begin

      {random : reverse}

      Ball[k].ReverseD := NOT Ball[k].ReverseD;
      Ball[k].RevTimer := 10;

      end;
    end;

    if Ball[k].RevTimer > 0 then
      Dec(Ball[k].RevTimer);

    if Random(20) = 0 then
    begin
      Ball[k].Sleep := True;
      Ball[k].SleepTimer := 10;
    end;

    if Ball[k].SleepTimer > 0 then
      Dec(Ball[k].SleepTimer);

    if Ball[k].Sleep then
      if Ball[k].SleepTimer <= 0 then
        Ball[k].Sleep := False;

    if Ball[k].SeesPlayer then
      Ball[k].Sleep := False;

    if Ball[k].X < Ball[k].XTraject_lo then
      Ball[k].ReverseD := False
    else
      if Ball[k].X > Ball[k].XTraject_hi then
        Ball[k].ReverseD := True;

  end;

{  PicView := Random(3);}

{  SetColor(10);
  Bar(0, 50, 200, 500);}

(*  for j := 0 to A20_Y-1 do
    for i := 0 to A20_X-1 do
    begin
      if PlC.ReverseD then
      begin
        if TEX_A20[PicView,i,j].Color16 <> -1 then
          PutPixel(-i+PlC.X+(A20_X DIV 2)-1, j+PlC.Y-(A20_Y DIV 2), TEX_A20[PicView,i,j].Color16);
      end
      else
      begin
        if TEX_A20[PicView,i,j].Color16 <> -1 then
          PutPixel(i+PlC.X-(A20_X DIV 2), j+PlC.Y-(A20_Y DIV 2), TEX_A20[PicView,i,j].Color16);
      end;
    end; *)

  PlC.VPX2 := PlC.VPX;
  PlC.VPY2 := PlC.VPY;

  PlC.VPX := PlC.X;
  PlC.VPY := PlC.Y;

  { Below PlayCharacter movement + collision}

  for SubCycles := 1 to {10}{10}{3}{1}{2}3 do
  begin

  PlC.PX := PlC.X;
  PlC.PY := PlC.Y;

(*  if Ball[0].SeesPlayer then
    ScanCode := 1
  else
    ScanCode := 0; *)

(*  X0 := Ball[0].X;
  X1 := PlC.X;
  Y0 := Ball[0].Y;
  Y1 := PlC.Y;

  ScanCode2 := Round(Sqrt(Abs(Sqr(X0-X1)+Sqr(Y0-Y1))+1E-1)) DIV 10; *)

{.  Str(ScanCode, StrOut);

  OutTextXY(100, 100, StrOut);}

{  if C = Chr(77) then}
  if ArrR = 1 then
  begin

(*    Inc(PlC.X, {2}8);*)
    PlC.ReverseD := False;
    PlC.WalkRight := True;
    PlC.WalkLeft := False;
  end
  else
    if ArrR = {2}0 then
    begin
      PlC.WalkRight := False;
    end
(*    else
      if ArrR = 0 then
      begin
        PlC.WalkRight := False;
      end*);

  if ArrL = 1 then
  begin

(*    Inc(PlC.X, {2}8);*)
    PlC.ReverseD := True;
    PlC.WalkLeft := True;
    PlC.WalkRight := False;
  end
  else
    if {ArrR}ArrL = {2}0 then
    begin
      PlC.WalkLeft := False;
    end
(*    else
      if ArrR = 0 then
      begin
        PlC.WalkLeft := False;
      end*);

  if CTRL = 1 then
  begin

(*    Inc(PlC.X, {2}8);*)
    {PlC.ReverseD := True;}
    if JumpCollision then
    begin
      PlC.Jump := True;
      PlC.JumpTime := 0;
      {PlC.WalkLeft := False;
      PlC.WalkRight := False;}
    end;
  end
  else
    if CTRL = {2}0 then
    begin
      PlC.Jump := False;
    end
(*    else
      if CTRL = 0 then
      begin
        PlC.Jump := False;
      end*);

(*  else
    if ArrP = 2 then
    begin
      Dec(PlC.X, {2}8);
      PlC.ReverseD := True;
    end;
      if ArrP = 3 then
      begin
        Dec(PlC.Y, {2}12);
      end; *)

  if NOT JumpCollision then
    Dec(TSurfaceContact)
  else
    TSurfaceContact := 4;

  if (PlC.JumpTime = 0) {AND JumpCollision} then
  begin

  if TSurfaceContact > 0 then
  begin

  PlC.SpdRec := 0;

  if PlC.WalkRight then
  begin
    Inc(PlC.X, {2}{8}4);
    Inc(PlC.SpdRec, 4);
  end;

  if PlC.WalkLeft then
  begin
    Dec(PlC.X, {2}{8}4);
    Dec(PlC.SpdRec, 4);
  end;

  end;

  end
  else
    PlC.X := PlC.X + (PlC.SpdRec) DIV ((PlC.JumpTime DIV 10)+1);

  if PlC.CancelJump then
    PlC.Jump := False;

  if (PlC.Jump){ AND (PlC.JumpTime < 20)} then
  begin
    if (PlC.JumpTime < {24}15) then
    begin
      if NOT PlC.CancelJump then
        Dec(PlC.Y, {24}{15}18-PlC.JumpTime);
      Inc(PlC.JumpTime);
(*      SFreq := (500 DIV (PlC.Y DIV 20))*PlC.JumpTime;*)
    end;
  end;

  if JumpCollision then
  begin
    PlC.JumpTime := 0;
    SFreq := 0;
    PlC.CancelJump := False;
  end;

  if {(NOT PlayerCollision) OR} (NOT JumpCollision) then
    Inc(PlC.Y, {3}{11}{9}{3} PlC_Gravity)
  else
    Inc(PlC.Y, {3}{11}{9}0);

  PlayerCollision := False;

    Xcheck := False;
    Ycheck := False;

    Yup := False;

    Xlft := False;

  for i := 0 to 119 do
    for j := 0 to 119 do
    begin
      CollisionMatrixA[i,j] := 0;
      CollisionMatrixB[i,j] := 0;
    end;

(*  DistClosestObj := -1;

  for k := 0 to (NrOfBars-1) do
    if (Sqrt(1E-1+Abs(Sqr(PlC.X-WlkB[k].X)+Sqr(PlC.Y-WlkB[k].Y))) < DistClosestObj) OR (DistClosestObj < 0) then
    begin
      DistClosestObj := Sqrt(1E-1+Abs(Sqr(PlC.X-WlkB[k].X)+Sqr(PlC.Y-WlkB[k].Y)));
      ClosestObj := k;
    end; *)

  JumpCollision := False;

(*  for k := {0}ClosestObj-1 to {3}ClosestObj+1 do
  if (k >= 0) AND (k <= 3) then {note k := 1..3!!}*)
  for k := 0 to (NrOfBars-1) do
  begin

(*  for i := 0 to 119 do
    for j := 0 to 119 do
    begin
      CollisionMatrixA[i,j] := 0;
      CollisionMatrixB[i,j] := 0;
    end; *)

(*  if Sqrt(1E-1+Abs(Sqr(PlC.X-WlkB[k].X)+Sqr(PlC.Y-WlkB[k].Y))) < {60}60 then*)
  begin

  begin
    for i := 0 to A20_X-1 do
      for j := 0 to A20_Y-1 do
      begin
        if PlC.ReverseD then
          Xco := (-i+59+(PlC.X-((PlC.X{+WlkB[ClosestObj].X}) {DIV 2}))+(A20_X DIV 2)-1)
        else
          Xco := (i+59+(PlC.X-((PlC.X{+WlkB[ClosestObj].X}) {DIV 2}))-(A20_X DIV 2));
        Yco := (j+59+(PlC.Y-((PlC.Y{+WlkB[ClosestObj].Y}) {DIV 2}))-(A20_Y DIV 2));
        if (Xco >= 0) AND (Xco < 120) then
        if (Yco >= 0) AND (Yco < 120) then
        begin
        if TEX_A20[PlC.PicView,i,j].Color16 < 0 then
          CollisionMatrixA[{(i+59+(PlC.X-WlkB[k].X)-(A20_X DIV 2))}Xco,{j+59+(PlC.Y-WlkB[k].Y)-(A20_Y DIV 2)}Yco] := -1
        else
          CollisionMatrixA[{(i+59+(PlC.X-WlkB[k].X)-(A20_X DIV 2))}Xco,{j+59+(PlC.Y-WlkB[k].Y)-(A20_Y DIV 2)}Yco] := 1
            {TEX_A20[PicView,i,j].Color16};
        end;
      end;
    for i := 0 to B10_X-1 do
      for j := 0 to B10_Y-1 do
      begin
        Xco := (i+59+(WlkB[{ClosestObj}k].X-((PlC.X{+WlkB[ClosestObj].X}) {DIV 2}))-(B10_X DIV 2));
        Yco := (j+59+(WlkB[{ClosestObj}k].Y-((PlC.Y{+WlkB[ClosestObj].Y}) {DIV 2}))-(B10_Y DIV 2));
        if (Xco >= 0) AND (Xco < 120) then
        if (Yco >= 0) AND (Yco < 120) then
        begin
        if TEX_B10[0,i,j].Color16 < 0 then
          CollisionMatrixB[{(i+59+(PlC.X-WlkB[k].X)-(B10_X DIV 2))}Xco,{j+59+(PlC.Y-WlkB[k].Y)-(B10_Y DIV 2)}Yco] := -1
        else
          CollisionMatrixB[{(i+59+(PlC.X-WlkB[k].X)-(B10_X DIV 2))}Xco,{j+59+(PlC.Y-WlkB[k].Y)-(B10_Y DIV 2)}Yco] := 1
            {TEX_B10[0,i,j].Color16};
        end;
      end;

  end;

(*    Xcheck := False;
    Ycheck := False;*)

 {----}

 {----}

(*  if (PlayerCollision) {AND (PlC.X >= WlkB[k].X) AND ()} then
  begin
    if Xcheck then
      PlC.X := PlC.PX;
    if Ycheck then
      PlC.Y := PlC.PY;
  end;*)

  end;

  end;

(*  if (PlayerCollision) AND (PlC.X >= WlkB[k].X) then
    Dec(PlC.Y, {4}6); *)

    for i := 3 to 116 do
      for j := 3 to 116 do
      begin
        if {(CollisionMatrixA[i,j]*CollisionMatrixB[i,j] > 0) AND}
          (CollisionMatrixA[i,j] > 0) AND (CollisionMatrixB[i,j] > 0) then
        begin
          PlayerCollision := True;
{          PutPixel(120+i, 40+j, 15);}


(*          Xcollision := True;
          Ycollision := True;

          if {NOT} ((CollisionMatrixA[i-1,j] <> 1) OR (CollisionMatrixB[i-1,j] <> 1)) AND (PlC.X-PlC.PX >= 1) then
          begin
            Xcollision := False;
            Xlft := True;
          end;

          if {NOT} ((CollisionMatrixA[i+1,j] <> 1) OR (CollisionMatrixB[i+1,j] <> 1)) AND (PlC.X-PlC.PX <= -1) then
          begin
            Xcollision := False;
            Xlft := False;
          end;

          if {NOT} ((CollisionMatrixA[i,j-5] <> 1) OR (CollisionMatrixB[i,j-5] <> 1)) AND (PlC.Y-PlC.PY >= 0) then
          begin
            Ycollision := False;
            Yup := True;
            JumpCollision := True;
          end;

          if {NOT} ((CollisionMatrixA[i,j+5] <> 1) OR (CollisionMatrixB[i,j+5] <> 1)) AND (PlC.Y-PlC.PY <= 0) then
          begin
            Ycollision := False;
            Yup := False;
          end;

          if NOT Xcollision then
            Xcheck := True;

          if NOT Ycollision then
            Ycheck := True; *)

        end;
(*        if (CollisionMatrixA[i,j] > 0) OR (CollisionMatrixB[i,j] > 0) then
        begin
          PutPixel(120+i, 40+j, {CollisionMatrixA[i,j]}15);
          {PutPixel(i,j,TEX_A20[PicView,i,j].Color16)};
        end; *)
      end;


  if (PlayerCollision) {AND (PlC.X >= WlkB[k].X) AND ()} then
  begin

    CollisionOnhold := {6}10;

(*    Dec(PlC.Y, {4}6);*)
{    if Xcheck then}
    begin

      TotalRowsColl := 0;

      for j := 3 to 116 do
      begin
        RowCollision := False;
        for i := 3 to 116 do
        begin
          if (CollisionMatrixA[i,j] > 0) AND (CollisionMatrixB[i,j] > 0) then
            RowCollision := True;
        end;
        if RowCollision then
          Inc(TotalRowsColl);
      end;

      if (TotalRowsColl >= {4}{3}CollisionThicknessX) {AND (Abs(PlC.X-PlC.PX) >= 0)}AND (Abs(PlC.X-PlC.PX) >= {1}CollisionVelocityX) then
      begin

      {---}

      TotalCollumnsColl := 0;

      for i := 3 to 116 do
      begin
        CollumnCollision := False;
        for j := 3 to 116 do
        begin
          if (CollisionMatrixA[i,j] > 0) AND (CollisionMatrixB[i,j] > 0) then
            CollumnCollision := True;
        end;
        if CollumnCollision then
          Inc(TotalCollumnsColl);
      end;

(*      if Xlft then
        PlC.X := PlC.X-TotalCollumnsColl
      else
        PlC.X := PlC.X+TotalCollumnsColl;*)

      UpperX := PlC.X-TotalCollumnsColl;
      LowerX := PlC.X+TotalCollumnsColl;

      if (PlC.X > UpperX) AND (PlC.X-PlC.PX > {0}0) then
      begin
//        PlC.X := PlC.X-Round(TotalCollumnsColl*1.5);
        PlC.X := Round(UpperX-{2.0}UpperPlC_ClampX);
        PlC.Y := PlC.Y - Round((PlC.Y-PlC.PY)*SlowDownY);
(*        if TotalCollumnsColl > {3}1 then *)
          {WaitAndRefresh := True;}
      end
      else
        if (PlC.X < UpperX) AND (PlC.X-PlC.PX < 0) then
        begin
//          PlC.X := PlC.X+Round(TotalCollumnsColl*1.5);
          PlC.X := Round(UpperX+{2.0}UpperPlC_ClampX);
          PlC.Y := PlC.Y - Round((PlC.Y-PlC.PY)*SlowDownY);
(*          if TotalCollumnsColl > {3}1 then*)
            {WaitAndRefresh := True;}
        end
{        else
          WaitAndRefresh := True};

  {    PlC.X := PlC.PX;}

      end
(*      else
{        if NOT SurfaceContact then}
        {if PlC.Y > PlC.PY then}
        if (PlC.SY > PlC.PSY) OR (PlC.SY < PlC.PSY) then
          if (TotalCollumnsColl >= {4}1) then
            WaitAndRefresh := True*);

    end;

(*        if (PlC.SY > PlC.PSY) OR (PlC.SY < PlC.PSY) then
            WaitAndRefresh := True; *)

{    if (PlC.SX > PlC.PSX) OR (PlC.SX < PlC.PSX) then}
(*      if ((PlC.SX > PlC.PSX) OR (PlC.SX < PlC.PSX)) OR ((PlC.SY > PlC.PSY) OR (PlC.SY < PlC.PSY)) then*)
{      if (PlC.SY > PlC.PSY) OR (NOT SurfaceContact) then}
    (*    if (TotalRowsColl >= {4}{2}2) then*)
(*      if {((PlC.SX > PlC.PSX) OR (PlC.SX < PlC.PSX)) OR} ((PlC.SY - PlC.PSY <> 0) {OR (PlC.SY < PlC.PSY)}) then
          WaitAndRefresh := True; *)

    SurfaceContact := False;

{    if Ycheck then}
    begin

(*      for j := PlC.Y to PlC.Y-3 do
        if CollisionMatrixB[i,j] *)

      TotalCollumnsColl := 0;

      for i := 3 to 116 do
      begin
        CollumnCollision := False;
        for j := 3 to 116 do
        begin
          if (CollisionMatrixA[i,j] > 0) AND (CollisionMatrixB[i,j] > 0) then
            CollumnCollision := True;
        end;
        if CollumnCollision then
          Inc(TotalCollumnsColl);
      end;

      if (TotalCollumnsColl >= {4}{3} {1}CollisionThicknessY) AND (Abs(PlC.Y-PlC.PY) >= {1}CollisionVelocityY) then
      begin

      { --- }

      TotalRowsColl := 0;

      for j := 3 to 116 do
      begin
        RowCollision := False;
        for i := 3 to 116 do
        begin
          if (CollisionMatrixA[i,j] > 0) AND (CollisionMatrixB[i,j] > 0) then
            RowCollision := True;
        end;
        if RowCollision then
          Inc(TotalRowsColl);
      end;

(*      if (*({Yup}PlC.Y-PlC.PY > 0) AND*) (PlC.Y+(A20_Y DIV 2) > GetMaxY) then
      begin
        PlC.Y := PlC.Y-Round(TotalRowsColl*1.5){Round(PlC.PY-0.5)}{GetMaxY-(A20_Y DIV 2)};
        {if TotalRowsColl > 3 then
          WaitAndRefresh := True;}
{          Refresh := 3;}
      end  *)

      UpperY := PlC.Y-TotalRowsColl;
      LowerY := PlC.Y+TotalRowsColl;

//      if (*({Yup}PlC.Y-PlC.PY > 0) AND*) (PlC.Y+(A20_Y DIV 2) > GetMaxY) then
      if (PlC.Y > UpperY) AND (PlC.Y-PlC.PY > 0) then
      begin
//        PlC.Y := PlC.Y-Round(TotalRowsColl*1.5){Round(PlC.PY-0.5)}{GetMaxY-(A20_Y DIV 2)};
        PlC.Y := Round(UpperY-{2.0}UpperPlC_ClampY);
        PlC.X := PlC.X - Round((PlC.X-PlC.PX)*{0.1}SlowDownX);

        JumpCollision := True;

        {if TotalRowsColl > 3 then
          WaitAndRefresh := True;}
{          Refresh := 3;}
      end
      else
        if (PlC.Y < LowerY) AND (PlC.Y-PlC.PY < 0) then
        begin
//          PlC.Y := PlC.Y+Round(TotalRowsColl*1.5);
          PlC.Y := Round(LowerY+{2.0}LowerPlC_ClampY);
          PlC.X := PlC.X - Round((PlC.X-PlC.PX)*{0.1}SlowDownX);
          PlC.CancelJump := True;
          {if TotalRowsColl > 3 then
            WaitAndRefresh := True;}
{          if TotalRowsColl > 2 then
            Refresh := 5;}
        end;

(*        PlC.Y := PlC.PY-(PlC.Y-PlC.PY);*)

//.        JumpCollision := True;

        SurfaceContact := True;

      end; {(TotalCollumnsColl >= 3)}

(*    if (PlC.SY > PlC.PSY) OR (PlC.SY < PlC.PSY) then
      WaitAndRefresh := True; *)

    end;
  end;

  // below : CollisionOnHold is obsolete.

  if CollisionOnhold > 0 then
    Dec(CollisionOnhold);

  if CollisionOnhold > 0 then
(*    if ((PlC.SY > PlC.PSY) OR (PlC.SY < PlC.PSY)) OR (NOT SurfaceContact) then*)
      if ((PlC.SY > PlC.PSY) OR (PlC.SY < PlC.PSY)) OR (TotalRowsColl >= {4}3) OR (NOT SurfaceContact) then
        WaitAndRefresh := True;

(*  if PlC.Y > GetMaxY-10 then
    PlC.Y := GetMaxY-10; *)

  if WaitAndRefresh then
(*    if NOT PlayerCollision{NOT SurfaceContact} then *)
    begin
      {pRefresh := True;}
      Refresh := {True}{3}3;
      WaitAndRefresh := False;
      DontClear := True;
    end;

  PlC.PSX := PlC.SX; {PlC.SY --> steady Y pos}

  PlC.SX := PlC.X;

  PlC.PSY := PlC.SY; {PlC.SY --> steady Y pos}

  PlC.SY := PlC.Y;

  { -- -- -- --}

  PlayerCollision := False;


  for i := 0 to 119 do
    for j := 0 to 119 do
    begin
      CollisionMatrixA[i,j] := 0;
      CollisionMatrixB[i,j] := 0;
    end;


{  JumpCollision := False;}

(*  for k := {0}ClosestObj-1 to {3}ClosestObj+1 do
  if (k >= 0) AND (k <= 3) then {note k := 1..3!!}*)
  for k := 0 to (NrOfFires-1) do
  begin


(*  if Sqrt(1E-1+Abs(Sqr(PlC.X-Fire[k].X)+Sqr(PlC.Y-Fire[k].Y))) < {60}60 then*)
  begin

  begin
    for i := 0 to A20_X-1 do
      for j := 0 to A20_Y-1 do
      begin
        if PlC.ReverseD then
          Xco := (-i+59+(PlC.X-((PlC.X{+WlkB[ClosestObj].X}) {DIV 2}))+(A20_X DIV 2)-1)
        else
          Xco := (i+59+(PlC.X-((PlC.X{+WlkB[ClosestObj].X}) {DIV 2}))-(A20_X DIV 2));
        Yco := (j+59+(PlC.Y-((PlC.Y{+WlkB[ClosestObj].Y}) {DIV 2}))-(A20_Y DIV 2));
        if (Xco >= 0) AND (Xco < 120) then
        if (Yco >= 0) AND (Yco < 120) then
        begin
        if TEX_A20[PlC.PicView,i,j].Color16 < 0 then
          CollisionMatrixA[{(i+59+(PlC.X-WlkB[k].X)-(A20_X DIV 2))}Xco,{j+59+(PlC.Y-WlkB[k].Y)-(A20_Y DIV 2)}Yco] := -1
        else
          CollisionMatrixA[{(i+59+(PlC.X-WlkB[k].X)-(A20_X DIV 2))}Xco,{j+59+(PlC.Y-WlkB[k].Y)-(A20_Y DIV 2)}Yco] := 1
            {TEX_A20[PicView,i,j].Color16};
        end;
      end;
    for i := 0 to A10_X-1 do
      for j := 0 to A10_Y-1 do
      begin
        Xco := (i+59+(Fire[{ClosestObj}k].X-((PlC.X{+WlkB[ClosestObj].X}) {DIV 2}))-(A10_X DIV 2));
        Yco := (j+59+(Fire[{ClosestObj}k].Y-((PlC.Y{+WlkB[ClosestObj].Y}) {DIV 2}))-(A10_Y DIV 2));
        if (Xco >= 0) AND (Xco < 120) then
        if (Yco >= 0) AND (Yco < 120) then
        begin
        if TEX_A10[0,i,j].Color16 < 0 then
          CollisionMatrixB[{(i+59+(PlC.X-WlkB[k].X)-(B10_X DIV 2))}Xco,{j+59+(PlC.Y-WlkB[k].Y)-(B10_Y DIV 2)}Yco] := -1
        else
          CollisionMatrixB[{(i+59+(PlC.X-WlkB[k].X)-(B10_X DIV 2))}Xco,{j+59+(PlC.Y-WlkB[k].Y)-(B10_Y DIV 2)}Yco] := 1
            {TEX_B10[0,i,j].Color16};
        end;
      end;

  end;

(*    Xcheck := False;
    Ycheck := False;*)

 {----}

 {----}

(*  if (PlayerCollision) {AND (PlC.X >= WlkB[k].X) AND ()} then
  begin
    if Xcheck then
      PlC.X := PlC.PX;
    if Ycheck then
      PlC.Y := PlC.PY;
  end;*)

  end;

  end;

(*  if (PlayerCollision) AND (PlC.X >= WlkB[k].X) then
    Dec(PlC.Y, {4}6); *)

    for i := 3 to 116 do
      for j := 3 to 116 do
      begin
        if {(CollisionMatrixA[i,j]*CollisionMatrixB[i,j] > 0) AND}
          (CollisionMatrixA[i,j] > 0) AND (CollisionMatrixB[i,j] > 0) then
        begin
          PlayerCollision := True;
{          PutPixel(120+i, 40+j, 15);}


        end;
(*        if (CollisionMatrixA[i,j] > 0) OR (CollisionMatrixB[i,j] > 0) then
        begin
          PutPixel(120+i, 40+j, {CollisionMatrixA[i,j]}15);
          {PutPixel(i,j,TEX_A20[PicView,i,j].Color16)};
        end; *)
      end;

  if PlayerCollision then
  begin

    PlC.X := {100}60;
    PlC.Y := (GetMaxY-9)-100;

    {ClearDevice;}
    XWnd := 0;
    {pRefresh := True;}
    Refresh := {True}3;
    DontClear := {True}False;

  end;

  { -- -- -- --}

  { -- -- -- below collision NPCs}

  { -- -- -- --}

  PlayerCollision := False;


  for i := 0 to 119 do
    for j := 0 to 119 do
    begin
      CollisionMatrixA[i,j] := 0;
      CollisionMatrixB[i,j] := 0;
    end;


{  JumpCollision := False;}

(*  for k := {0}ClosestObj-1 to {3}ClosestObj+1 do
  if (k >= 0) AND (k <= 3) then {note k := 1..3!!}*)
  for k := 0 to (NrOfBalls-1) do
  begin


(*  if Sqrt(1E-1+Abs(Sqr(PlC.X-Fire[k].X)+Sqr(PlC.Y-Fire[k].Y))) < {60}60 then*)
  begin

  begin
    for i := 0 to A20_X-1 do
      for j := 0 to A20_Y-1 do
      begin
        if PlC.ReverseD then
          Xco := (-i+59+(PlC.X-((PlC.X{+WlkB[ClosestObj].X}) {DIV 2}))+(A20_X DIV 2)-1)
        else
          Xco := (i+59+(PlC.X-((PlC.X{+WlkB[ClosestObj].X}) {DIV 2}))-(A20_X DIV 2));
        Yco := (j+59+(PlC.Y-((PlC.Y{+WlkB[ClosestObj].Y}) {DIV 2}))-(A20_Y DIV 2));
        if (Xco >= 0) AND (Xco < 120) then
        if (Yco >= 0) AND (Yco < 120) then
        begin
        if TEX_A20[PlC.PicView,i,j].Color16 < 0 then
          CollisionMatrixA[{(i+59+(PlC.X-WlkB[k].X)-(A20_X DIV 2))}Xco,{j+59+(PlC.Y-WlkB[k].Y)-(A20_Y DIV 2)}Yco] := -1
        else
          CollisionMatrixA[{(i+59+(PlC.X-WlkB[k].X)-(A20_X DIV 2))}Xco,{j+59+(PlC.Y-WlkB[k].Y)-(A20_Y DIV 2)}Yco] := 1
            {TEX_A20[PicView,i,j].Color16};
        end;
      end;
    for i := 0 to C30_X-1 do
      for j := 0 to C30_Y-1 do
      begin
        Xco := (i+59+(Ball[{ClosestObj}k].X-((PlC.X{+WlkB[ClosestObj].X}) {DIV 2}))-(C30_X DIV 2));
        Yco := (j+59+(Ball[{ClosestObj}k].Y-((PlC.Y{+WlkB[ClosestObj].Y}) {DIV 2}))-(C30_Y DIV 2));
        if (Xco >= 0) AND (Xco < 120) then
        if (Yco >= 0) AND (Yco < 120) then
        begin
        if TEX_C30[0,i,j].Color16 < 0 then
          CollisionMatrixB[{(i+59+(PlC.X-WlkB[k].X)-(B10_X DIV 2))}Xco,{j+59+(PlC.Y-WlkB[k].Y)-(B10_Y DIV 2)}Yco] := -1
        else
          CollisionMatrixB[{(i+59+(PlC.X-WlkB[k].X)-(B10_X DIV 2))}Xco,{j+59+(PlC.Y-WlkB[k].Y)-(B10_Y DIV 2)}Yco] := 1
            {TEX_B10[0,i,j].Color16};
        end;
      end;

  end;

(*    Xcheck := False;
    Ycheck := False;*)

 {----}

 {----}

(*  if (PlayerCollision) {AND (PlC.X >= WlkB[k].X) AND ()} then
  begin
    if Xcheck then
      PlC.X := PlC.PX;
    if Ycheck then
      PlC.Y := PlC.PY;
  end;*)

  end;

  end;

(*  if (PlayerCollision) AND (PlC.X >= WlkB[k].X) then
    Dec(PlC.Y, {4}6); *)

    for i := 3 to 116 do
      for j := 3 to 116 do
      begin
        if {(CollisionMatrixA[i,j]*CollisionMatrixB[i,j] > 0) AND}
          (CollisionMatrixA[i,j] > 0) AND (CollisionMatrixB[i,j] > 0) then
        begin
          PlayerCollision := True;
{          PutPixel(120+i, 40+j, 15);}


        end;
(*        if (CollisionMatrixA[i,j] > 0) OR (CollisionMatrixB[i,j] > 0) then
        begin
          PutPixel(120+i, 40+j, {CollisionMatrixA[i,j]}15);
          {PutPixel(i,j,TEX_A20[PicView,i,j].Color16)};
        end; *)
      end;

  if PlayerCollision {OR (PlC.Y > GetMaxY)} then
  begin

    PlC.X := {100}60;
    PlC.Y := (GetMaxY-9)-100;

{    ClearDevice;}
    XWnd := 0;
    {pRefresh := True;}
    Refresh := {True}3;
    DontClear := {True}False;

  end;

  { -- -- -- --}


  end; {SubCycles}

  if{ PlayerCollision} {OR} (PlC.Y > GetMaxY) then
  begin

    PlC.X := {100}60;
    PlC.Y := (GetMaxY-9)-100;

{    ClearDevice;}
    XWnd := 0;
    {pRefresh := True;}
    Refresh := {True}3;
    DontClear := {False}{True}False;

  end;

  if (PlC.X < GetMaxX+4) AND (XWnd <> 0) then
  begin
{    ClearDevice;}
    XWnd := 0;
    Refresh := {True}3;
    DontClear := False;
  end;

  if (PlC.X > GetMaxX-4) AND (XWnd <> -GetMaxX) then
  begin
{    ClearDevice;}
    XWnd := -GetMaxX; {next window}
    Refresh := {True}3;
    DontClear := False;
  end;

  if PlC.X < 0 then
    PlC.X := 0;


  DrawPixels_2;

{  end;}

//.  until Esc = 1;

end;


end.

