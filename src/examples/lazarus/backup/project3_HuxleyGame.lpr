program project3_HuxleyGame;

// HuxleyGame : Code of the 2D game 'Heroic Huxley' written by Roelof Emmerink (rpe86@hotmail.com)
// generates training data meant to use with Keras4Delphi. (for a CNN/LSTM network)

// This game makes use of Allegro 5. See Allegro5.pas and file LICENSE

// c:\TrainingsData-Huxley and c:\GAMETEX must exist

{$APPTYPE GUI}

uses Allegro5, al5font, Huxley142_unit1, al5base, al5image, al5strings, al5video, al5memfile, al5color,
Bitmaps_unit2, SysUtils;

var Timer : ALLEGRO_TIMERptr;
    Queue : ALLEGRO_EVENT_QUEUEptr;
    Event : ALLEGRO_EVENT;
    Display : ALLEGRO_DISPLAYptr;
    Font : ALLEGRO_FONTptr;

    Redraw, EndProgram : Boolean;

    Color : ALLEGRO_COLOR;

    Xco, Yco : Longint;

    Bitmap1, Bitmap2, Bitmap3 : ALLEGRO_BITMAPptr;

    fname1 : AL_STR;

    F : TextFile;

begin

  Assign(F, 'C:\TrainingsData-Huxley\keylog.txt');
  Rewrite(F);

  al_init;
  al_install_keyboard;

  al_init_image_addon;

  FileName := 'c:\GAMETEX\FLAME23.png';

  Bitmap_FL23 := al_load_bitmap (FileName);

  al_convert_mask_to_alpha(Bitmap_FL23, al_map_rgb(0, 0, 0));

  FileName := 'c:\GAMETEX\FLAME33.png';

  Bitmap_FL33 := al_load_bitmap (FileName);

  al_convert_mask_to_alpha(Bitmap_FL33, al_map_rgb(0, 0, 0));

  FileName := 'c:\GAMETEX\FLAME43.png';

  Bitmap_FL43 := al_load_bitmap (FileName);

  al_convert_mask_to_alpha(Bitmap_FL43, al_map_rgb(0, 0, 0));

  FileName := 'c:\GAMETEX\WALKBAR1.png';

  Bitmap_WB1 := al_load_bitmap (FileName);

  al_convert_mask_to_alpha(Bitmap_WB1, al_map_rgb(101, 101, 101));

  FileName := 'c:\GAMETEX\DOLLWLK12.png';

  Bitmap_DW1 := al_load_bitmap (FileName);

  al_convert_mask_to_alpha(Bitmap_DW1, al_map_rgb(0, 0, 170));

  FileName := 'c:\GAMETEX\DOLLWLK22.png';

  Bitmap_DW2 := al_load_bitmap (FileName);

  al_convert_mask_to_alpha(Bitmap_DW2, al_map_rgb(0, 0, 170));

  FileName := 'c:\GAMETEX\DOLLWLK32.png';

  Bitmap_DW3 := al_load_bitmap (FileName);

  al_convert_mask_to_alpha(Bitmap_DW3, al_map_rgb(0, 0, 170));

  FileName := 'c:\GAMETEX\BALL101.png';

  Bitmap_B101 := al_load_bitmap (FileName);

  al_convert_mask_to_alpha(Bitmap_B101, al_map_rgb(0, 0, 255));

  FileName := 'c:\GAMETEX\BALL102.png';

  Bitmap_B102 := al_load_bitmap (FileName);

  al_convert_mask_to_alpha(Bitmap_B102, al_map_rgb(0, 0, 255));

  FileName := 'c:\GAMETEX\BALL103.png';

  Bitmap_B103 := al_load_bitmap (FileName);

  al_convert_mask_to_alpha(Bitmap_B103, al_map_rgb(0, 0, 255));

  FileName := 'c:\GAMETEX\BALL104.png';

  Bitmap_B104 := al_load_bitmap (FileName);

  al_convert_mask_to_alpha(Bitmap_B104, al_map_rgb(0, 0, 255));


  InitHuxley;

  Timer := al_create_timer({1/30}{1/50}1/18);
  Queue := al_create_event_queue;

  al_set_new_display_flags(ALLEGRO_FULLSCREEN);
  Display := al_create_display({320}GetMaxX+1, {200}GetMaxY+1);
  Font := al_create_builtin_font;

  Bitmap1 := al_create_bitmap(GetMaxX+1, GetMaxY+1);

  Bitmap2 := al_create_bitmap({160}140, {120}105);

  Bitmap3 := al_create_bitmap({160}60, {120}45);

  al_register_event_source (Queue, al_get_keyboard_event_source);
  al_register_event_source (Queue, al_get_display_event_source(Display));
  al_register_event_source (Queue, al_get_timer_event_source(Timer));

  Redraw := True;
  EndProgram := False;

  Esc := 0;

  al_start_timer(Timer);
  repeat
    al_wait_for_event(Queue, @Event);

    if Event.ftype = ALLEGRO_EVENT_TIMER then
      Redraw := True
    else
        if (Event.ftype = ALLEGRO_EVENT_DISPLAY_CLOSE) then
          EndProgram := True
        else
          if (Event.ftype = ALLEGRO_EVENT_KEY_DOWN) then
          begin
            if Event.keyboard.keycode = ALLEGRO_KEY_RIGHT then
              ArrR := 1;
            if Event.keyboard.keycode = ALLEGRO_KEY_LEFT then
              ArrL := 1;
            if Event.keyboard.keycode = ALLEGRO_KEY_RCTRL then
              Ctrl := 1;
            if Event.keyboard.keycode = ALLEGRO_KEY_ESCAPE then
              Esc := 1;
          end
          else
            if (Event.ftype = ALLEGRO_EVENT_KEY_UP) then
            begin
              if Event.keyboard.keycode = ALLEGRO_KEY_RIGHT then
                ArrR := 0;
              if Event.keyboard.keycode = ALLEGRO_KEY_LEFT then
                ArrL := 0;
              if Event.keyboard.keycode = ALLEGRO_KEY_RCTRL then
                Ctrl := 0;
              if Event.keyboard.keycode = ALLEGRO_KEY_ESCAPE then
                Esc := 1;
            end;

    if Esc = 1 then
      EndProgram := True;

    if Redraw AND al_is_event_queue_empty(Queue) then
    begin

      al_set_target_bitmap(Bitmap1);

      al_clear_to_color(al_map_rgb(101, 101, 101));

      ProcessPhysics;

      al_set_target_bitmap(al_get_backbuffer(Display));

      al_draw_bitmap(Bitmap1, 0, 0, 0);

      al_flip_display;

      Redraw := FALSE;

      if Cycles MOD {10}9 = 0 then
      begin

        al_set_target_bitmap(Bitmap2); // small output buffer

        al_clear_to_color(al_map_rgb(101, 101, 101));

        al_draw_scaled_bitmap(Bitmap1, 0, 0, GetMaxX+1, GetMaxY+1, 0, 0, {160}140, {120}105, 0);

        fname1 := 'c:\TrainingsData-Huxley\' + 'allegro-scr-' + IntToStr(Cycles {DIV 2}) + '_LRG' + '.bmp';

        al_save_bitmap(fname1, Bitmap2);

      end;

        //

      if Cycles MOD 2 = 0 then
      begin

        al_set_target_bitmap(Bitmap3); // extra small output buffer

        al_clear_to_color(al_map_rgb(101, 101, 101));

        al_draw_scaled_bitmap(Bitmap1, 0, 0, GetMaxX+1, GetMaxY+1, 0, 0, {160}60, {120}45, 0);

        fname1 := 'c:\TrainingsData-Huxley\' + 'allegro-scr-' + IntToStr(Cycles {DIV 2}) + '_SML' + '.bmp';

        al_save_bitmap(fname1, Bitmap3);

      end;

      if Cycles MOD 1 = 0 then
      begin

        Writeln(F, IntToStr(Cycles), ' - ', 'ArrR : ', IntToStr(ArrR), ' ArrL : ', IntToStr(ArrL), ' Ctrl : ', IntToStr(Ctrl));

      end;

    end;
  until EndProgram;

  al_destroy_font(Font);
  al_destroy_display(Display);
  al_destroy_timer(Timer);
  al_destroy_event_queue(Queue);

  Close(F);

end.

