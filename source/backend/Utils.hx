package backend;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.touch.FlxTouch;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.utils.Assets;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
#if android
import haxe.crypto.Md5; // Assim o Md5 não é compilado no PC e não fica como Unused import

#end
using StringTools;

enum ResizeMode
{
  FIT_WIDTH;
  FIT_HEIGHT;
  NONE;
}

enum FlxScrollbarOrientation
{
  VERTICAL;
  HORIZONTAL;
}


/**
 * Usado para funções de touch (Mobile) e mouse (Desktop)
 */
class BSLTouchUtils
{
  // Code por Matheus Silver e Lorena provavelmente
  public static var prevTouched:Int = -1;

  /**
   * Retorna verdadeiro ou falso caso você dê um Toque na tela (Mobile) ou aperte o botão do Mouse (Desktop)
   */
  public static function justTouched():Bool // Copiado do Hsys k
  {
    #if (flixel && android)
    var justTouched:Bool = false;

    for (touch in FlxG.touches.list)
    {
      if (touch.justPressed) justTouched = true;
    }

    return justTouched;
    #else
    return FlxG.mouse.justPressed; // Isso aqui é mais válido pro modboa mas né?
    #end
  }

  /**
   * Retorna verdadeiro ou falso caso você esteja com Segurando o toque na tela (Mobile) ou Segurando o botão do Mouse (Desktop).
   */
  public static function touched():Bool
  {
    #if (flixel && android)
    var touched:Bool = false;

    for (touch in FlxG.touches.list)
    {
      if (touch.pressed) touched = true;
    }

    return touched;
    #else
    return FlxG.mouse.pressed;
    #end
  }

  /**
   * solo para ver el mousescreen.
   */
  public static function touchScreenX():Float
  {
    // #if (flixel && android)
    var touch:FlxTouch = FlxG.touches.getFirst();

    if(touch != null) return touch.screenX;

    return 0; //espero que es to no rompa nada xd
    // #end
  }

  /**
   * solo para ver el mousescreen.
   */
   public static function touchScreenY():Float
   {
      // #if (flixel && android)
      var touch:FlxTouch = FlxG.touches.getFirst();

      if(touch != null) return touch.screenY;

      return 0;
      // #end
   }

  /**
   * Retorna verdadeiro ou falso caso tenha parado de Tocar na tela (Mobile) ou Soltado o botão do Mouse (Desktop).
   */
  public static function justSolto():Bool
  {
    #if (flixel && android)
    var justReleased:Bool = false;

    for (touch in FlxG.touches.list)
    {
      if (touch.justReleased) justReleased = true;
    }

    return justReleased;
    #else
    return FlxG.mouse.justReleased;
    #end
  }

  /**
   * Função para tocar em uma coisa duas vezes para poder realmente selecionar ele
   * @param coisas As coisas uai
   * @param coisasID Socorro Silvio nunca entendi como sua função (ou função da Lorena 🤔) funciona
   */
  public static function aperta(coisas:Dynamic,
      coisasID:Int):String // Esse code foi feito só pq em outro projeto, eu usei um padrãozinho deste várias vezes e fiquei com preguiça de fazer isso de novo
  {
    var leToqueOrdem:String = '';
    #if desktop
    if (over(coisas) && FlxG.mouse.justPressed && prevTouched == coisasID)
    {
      leToqueOrdem = 'segundo';
    }
    else if (over(coisas) && FlxG.mouse.justPressed)
    {
      prevTouched = coisasID;
      leToqueOrdem = 'primeiro';
    }
    #elseif mobile
    for (touch in FlxG.touches.list)
    {
      if (over(coisas) && touch.justPressed && prevTouched == coisasID) leToqueOrdem = 'segundo';
      else if (over(coisas) && touch.justPressed)
      {
        prevTouched = coisasID;
        leToqueOrdem = 'primeiro';
      }
    }
    #end
    return leToqueOrdem;
  }

  /**
   * Retorna verdadeiro ou falso caso você tenha apertado um objeto
   * @param coisa Texto, sprite ou qualquer coisa que será apertada
   */
  public static function apertasimples(coisa:Dynamic):Bool
  {
    #if desktop
    if (over(coisa) && FlxG.mouse.justPressed) return true;
    #elseif mobile
    for (touch in FlxG.touches.list)
      if (over(coisa) && touch.justPressed) return true;
    #end

    return false;
  }

  /**
   * Retorna verdadeiro ou falso caso o touch (Mobile) ou cursor (Desktop) sobreponha um objeto
   * @param coisa ..a coisa uai
   */
  public static function over(coisa:Dynamic):Bool
  {
    #if ios
    if (!Main.getMouseVisibility()) return false; // Provavelmente a única coisa que faz o BSLTouchUtils se pagar no ModBoa.
    return FlxG.mouse.overlaps(coisa);
    #elseif mobile
    for (touch in FlxG.touches.list)
      return touch.overlaps(coisa);
    #end

    return false;
  }

  /**
   * Retorna verdadeiro ou falso caso você esteja com Segurando o toque na tela (Mobile) ou Segurando o botão do Mouse (Desktop) em um objeto.
   * @param coisa ............. Tu já sabe né?
   */
  public static function pressionando(coisa:Dynamic):Bool
  {
    #if desktop
    return (over(coisa) && FlxG.mouse.pressed);
    #elseif mobile
    for (touch in FlxG.touches.list)
      if (over(coisa) && touch.justPressed && !touch.justReleased) return true;
    #end

    return false;
  }

  /**
   * Retorna verdadeiro ou falso caso tenha parado de Tocar na tela (Mobile) ou Soltado o botão do Mouse (Desktop) em um objeto.
   * @param coisa ............. Tu já sabe né?
   */
  public static function solto(coisa:Dynamic):Bool
  {
    #if desktop
    if (over(coisa) && FlxG.mouse.justReleased) return true;
    #elseif mobile
    for (touch in FlxG.touches.list)
      if (over(coisa) && touch.justReleased) return true;
    #end

    return false;
  }

  // Adaptação para um code bem antigo do ytb music
  public static function justsolto():Bool
  {
    #if desktop
    return FlxG.mouse.justReleased;
    #elseif mobile
    for (touch in FlxG.touches.list)
      return touch.justReleased;
    #end

    return false;
  }

  #if desktop
  /**
   * Retorna uma int da posição atual do seu mouse
   * @param pos A posição que tu quer (X ou Y) - deve ser escrita como "x" ou "y".
   */
  public static function pegarpos(pos:String):Int
  {
    if (pos == 'x') return FlxG.mouse.x;

    if (pos == 'y') return FlxG.mouse.y;

    return 0;
  }

  #elseif mobile
  /**
   * Retorna uma int da posição atual do seu toque
   * @param pos A posição que tu quer (X ou Y) - deve ser escrita como "x" ou "y".
   */
  public static function pegarpos(pos:String):Int
  {
    for (touch in FlxG.touches.list)
    {
      if (pos == 'x') return touch.x;

      if (pos == 'y') return touch.y;
    }
    return 0;
  }
  #end

  public static function teclado(acao:String)
  { // Converter para lua
    #if mobile
    if (acao == "abrir")
    {
      FlxG.stage.window.textInputEnabled = true;
    }
    else if (acao == "fechar")
    {
      FlxG.stage.window.textInputEnabled = false;
    }
    #else
    trace("Abrir/fechar teclado e uma funcao exclusiva do mobile.");
    #end
  }
}

/**
 * Simple scrollbar.  Draws itself and also handles dragging.  (It's up to you to use the provided data to update whatever you're scrolling.)
 * @author In the Beginning was the Word Game
 */
class FlxScrollbar extends FlxSpriteGroup
{
  private var _orientation:FlxScrollbarOrientation;
  private var _colour:FlxColor;
  private var _minProportion:Float = 0.1; // smallest barProportion of the track that the bar can be
  private var _track:FlxSprite; // Sits under the bar, and takes up the whole side.
  private var _bar:FlxSprite;
  private var _stale:Bool = true;
  private var _state:FlxState;
  private var _camera:FlxScrollableArea;
  private var _dragStartedAt:FlxPoint = null; // null signifying that we are not currently dragging, this is the mousedown spot
  private var _dragStartedWhenBarWasAt:Float; // the x or y (depending on orientation) of the bar at drag start (also for whole page movements)
  private var _trackClickCountdown = 0.0; // timer until you start getting repeated whole-page-movements when holding down the mouse button
  private var _mouseWheelMultiplier:Int;

  /**
   * Create a new scrollbar graphic.  You'll have to hide it yourself when needed.
   *
   * @param	X						As with any sprite.
   * @param	Y						"
   * @param	Width					"
   * @param	Height					"
   * @param	Orientation				Whether it's meant to operate vertically or horizontally.  (This is not assumed from the width/height.)
   * @param	Colour					The colour of the draggable part of the scrollbar.  The rest of it will be the same colour added to FlxColor.GRAY.
   * @param	Camera					The parent scrollable area to control with this scrollbar.
   * @param	InitiallyVisible		Bool to set .visible to.
       * @param	State					Which state to add the scrollbar(s) to.  If you're in a FlxSubState with its parent paused, pass it in here.
   * @param	MouseWheelMultiplier	How much to multiply mouse wheel deltas by.  Set to 0 to disable mouse wheeling.  Default 100.
   */
  public function new(X:Float, Y:Float, Width:Float, Height:Float, Orientation:FlxScrollbarOrientation, Colour:FlxColor, Camera:FlxScrollableArea,
      ?InitiallyVisible:Bool = false, ?State:FlxState, ?MouseWheelMultiplier:Int = 100)
  {
    super(X, Y);

    _state = State;
    if (_state == null) _state = FlxG.state;

    _orientation = Orientation;
    _colour = Colour;
    _camera = Camera;
    _mouseWheelMultiplier = MouseWheelMultiplier;

    _track = new FlxSprite();
    _track.makeGraphic(Std.int(Width), Std.int(Height), FlxColor.add(FlxColor.GRAY, _colour), true);
    add(_track);

    _bar = new FlxSprite();
    _bar.makeGraphic(Std.int(Width), Std.int(Height), _colour, true);
    add(_bar);

    visible = InitiallyVisible;
  }

  override public function draw()
  {
    if (_stale)
    {
      var barProportion:Float;
      var scrolledProportion:Float;
      if (_orientation == HORIZONTAL)
      {
        barProportion = FlxMath.bound(_track.width / _camera.content.width, _minProportion);
        _bar.makeGraphic(Std.int(_track.width * barProportion), Std.int(_track.height), _colour, true);
        if (_camera.content.width == _track.width) scrolledProportion = 0;
        else
          scrolledProportion = FlxMath.bound((_camera.scroll.x - _camera.content.x) / (_camera.content.width - _track.width), 0, 1);
        _bar.x = x + scrolledProportion * (_track.width * (1 - barProportion));
      }
      else
      {
        barProportion = FlxMath.bound(_track.height / _camera.content.height, _minProportion);
        _bar.makeGraphic(Std.int(_track.width), Std.int(_track.height * barProportion), _colour, true);
        if (_camera.content.height == _track.height) scrolledProportion = 0;
        else
          scrolledProportion = FlxMath.bound((_camera.scroll.y - _camera.content.y) / (_camera.content.height - _track.height), 0, 1);
        _bar.y = y + scrolledProportion * (_track.height * (1 - barProportion));
      }
      _stale = false;
    }
    super.draw();
  }

  override public function update(elapsed:Float)
  {
    if (!visible) return;
    var mousePosition = FlxPoint.get(Utils.BSLTouchUtils.pegarpos("x"), Utils.BSLTouchUtils.pegarpos("y"));
    var tryToScrollPage = false;
    if (Utils.BSLTouchUtils.justTouched())
    {
      if (_bar.overlapsPoint(mousePosition))
      {
        _dragStartedAt = mousePosition;
        if (_orientation == HORIZONTAL)
        {
          _dragStartedWhenBarWasAt = _bar.x;
        }
        else
        {
          _dragStartedWhenBarWasAt = _bar.y;
        }
      }
      else if (_track.overlapsPoint(mousePosition))
      {
        _trackClickCountdown = 0.5;
        if (_orientation == HORIZONTAL)
        {
          _dragStartedWhenBarWasAt = _bar.x;
        }
        else
        {
          _dragStartedWhenBarWasAt = _bar.y;
        }
        tryToScrollPage = true;
      }
    }
    else if (Utils.BSLTouchUtils.touched())
    {
      _trackClickCountdown -= elapsed;
      if (_trackClickCountdown < 0 && !_bar.overlapsPoint(mousePosition) && _track.overlapsPoint(mousePosition)) tryToScrollPage = true;
    }
    if (_dragStartedAt != null)
    {
      if (_orientation == HORIZONTAL)
      {
        if (mousePosition.y < (_camera.y + _camera.height / 2)) // allow 50% of height away before jumping back to original position
          mousePosition.x = _dragStartedAt.x;
        _bar.x = FlxMath.bound(_dragStartedWhenBarWasAt + (mousePosition.x - _dragStartedAt.x), _track.x, _track.x + _track.width - _bar.width);
      }
      else
      { // VERTICAL
        if (mousePosition.x < (_camera.x + _camera.width / 2)) // allow 50% of width away before jumping back to original position
          mousePosition.y = _dragStartedAt.y;
        _bar.y = FlxMath.bound(_dragStartedWhenBarWasAt + (mousePosition.y - _dragStartedAt.y), _track.y, _track.y + _track.height - _bar.height);
      }
      updateViewScroll();
    }
    else if (tryToScrollPage)
    {
      /**
       * Tries to scroll a whole viewport width/height toward wherever the mousedown on the track is.
       *
       * "Tries" because (to emulate standard scrollbar behaviour) you only scroll in one direction while holding the mouse button down.
       *
       * E.g. on a vertical scrollbar, if you click & hold below the bar, it scrolls down, but if, while still holding, you move to above the bar, nothing happens.
       */
      var whichWayToScroll:Int = 0; // 0: don't; 1: positive along axis; 2: negative along axis
      if (_orientation == HORIZONTAL)
      {
        if (_bar.x > _dragStartedWhenBarWasAt)
        { // scrolling right
          if (mousePosition.x > _bar.x + _bar.width) // and far enough right to scroll more
            whichWayToScroll = 1;
        }
        else if (_bar.x > _dragStartedWhenBarWasAt)
        { // scrolling left
          if (mousePosition.x < _bar.x) // and far enough left to scroll more
            whichWayToScroll = -1;
        }
        else
        { // first scroll...which way?
          if (mousePosition.x < _bar.x) // left of bar
            whichWayToScroll = -1;
          else // either right of bar, or on the bar; but if on the bar, execution shouldn't reach here in the first place
            whichWayToScroll = 1; // start scrolling right
        }
        if (whichWayToScroll == 1) _bar.x = FlxMath.bound(_bar.x + _bar.width, null, _track.x + _track.width - _bar.width);
        else if (whichWayToScroll == -1) _bar.x = FlxMath.bound(_bar.x - _bar.width, _track.x);
      }
      else
      { // VERTICAL
        if (_bar.y > _dragStartedWhenBarWasAt)
        { // scrolling down
          if (mousePosition.y > _bar.y + _bar.height) // and far enough down to scroll more
            whichWayToScroll = 1;
        }
        else if (_bar.y > _dragStartedWhenBarWasAt)
        { // scrolling up
          if (mousePosition.y < _bar.y) // and far enough up to scroll more
            whichWayToScroll = -1;
        }
        else
        { // first scroll...which way?
          if (mousePosition.y < _bar.y) // up of bar
            whichWayToScroll = -1;
          else // either down of bar, or on the bar; but if on the bar, execution shouldn't reach here in the first place
            whichWayToScroll = 1; // start scrolling down
        }
        if (whichWayToScroll == 1) _bar.y = FlxMath.bound(_bar.y + _bar.height, null, _track.y + _track.height - _bar.height);
        else if (whichWayToScroll == -1) _bar.y = FlxMath.bound(_bar.y - _bar.height, _track.y);
      }
      if (whichWayToScroll != 0) updateViewScroll();
    }
    #if !mobile
    else if (FlxG.mouse.wheel != 0)
    {
      if (_orientation == HORIZONTAL)
      {
        _bar.x = FlxMath.bound(_bar.x - FlxG.mouse.wheel * _mouseWheelMultiplier, _track.x, _track.x + _track.width - _bar.width);
      }
      else
      { // VERTICAL
        _bar.y = FlxMath.bound(_bar.y - FlxG.mouse.wheel * _mouseWheelMultiplier, _track.y, _track.y + _track.height - _bar.height);
      }
      updateViewScroll();
    }
    #end
    if (Utils.BSLTouchUtils.justSolto()) _dragStartedAt = null;
    super.update(elapsed);
  }

  /**
   * Updates the view's scroll.  Should be done from the outside if there's a resize.
   */
  public function updateViewScroll()
  {
    var scrolledProportion:Float;
    if (_orientation == HORIZONTAL)
    {
      if (_track.width == _bar.width) scrolledProportion = 0;
      else
        scrolledProportion = FlxMath.bound((_bar.x - x) / (_track.width - _bar.width), 0, 1);
      _camera.scroll.x = _camera.content.x + (_camera.content.width - _track.width) * scrolledProportion;
    }
    else
    {
      if (_track.height == _bar.height) scrolledProportion = 0;
      else
        scrolledProportion = FlxMath.bound((_bar.y - y) / (_track.height - _bar.height), 0, 1);
      _camera.scroll.y = _camera.content.y + (_camera.content.height - _track.height) * scrolledProportion;
    }
  }

  override private function set_width(Value:Float):Float
  {
    if (_track != null && _track.width != Value)
    {
      _track.makeGraphic(Std.int(Value), Std.int(height), FlxColor.add(FlxColor.GRAY, _colour), true);
      _stale = true;
    }
    return super.set_width(Value);
  }

  override private function set_height(Value:Float):Float
  {
    if (_track != null && _track.height != Value)
    {
      _track.makeGraphic(Std.int(width), Std.int(Value), FlxColor.add(FlxColor.GRAY, _colour), true);
      _stale = true;
    }
    return super.set_height(Value);
  }

  override private function set_x(Value:Float):Float
  {
    if (_track != null && x != Value)
    {
      _stale = true;
    }
    return super.set_x(Value);
  }

  override private function set_y(Value:Float):Float
  {
    if (_track != null && y != Value)
    {
      _stale = true;
    }
    return super.set_y(Value);
  }

  override private function set_visible(value:Bool):Bool
  {
    if (visible != value)
    {
      if (visible == false)
      { // becoming visible: make sure we're on top
        for (piece in [_track, _bar])
        {
          FlxG.state.remove(piece);
          FlxG.state.add(piece);
        }
      }
      return super.set_visible(value);
    }
    else
      return value;
  }

  public function forceRedraw()
  {
    if (visible) _stale = true;
  }
}

/**
 * An area of the screen that has automatic scrollbars, if needed.
 * @author In the Beginning was the Word Game
 */
class FlxScrollableArea extends FlxCamera
{
  /**
   * If your viewing area changes (perhaps in your state's onResize function) you need to update this to reflect it.
   */
  public var viewPort(default, set):FlxRect;

  /**
   * If your content's area changes (e.g. the content itself changes, or you override onResize), you need to update this to reflect it.
   */
  public var content(default, set):FlxRect;

  /**
   * Returns the best layout strategy you should use in your state's onResize function.  If you passed NONE in the constructor,
   * this function just returns that.
   *
   * Be sure to resize the viewport before calling this function, which will trigger a recalculation of this value and the scrollbar sizes.
   *
   * For example, you may normally want to FIT_WIDTH, so you pass that into the constructor.  But, at a certain resize ratio with a
   * certain content aspect ratio, there will be a conflict between this goal and whether there should be a scrollbar.  I.e., if your
   * content is resized to fit the width of the viewport, it will be too long and require a scrollbar.  But, if you resize it to allow for
   * a scrollbar, it will then be short enough not to need a scrollbar anymore.  In this case, .bestMode will tell you that you should
   * instead FIT_HEIGHT, so that, gracefully, you have no scrollbar, but still make things as big as possible.  I.e., your content will
   * take up part of what a scrollbar would have.
   *
   * Remember to also take into account the scrollbar thickness using horizontalScrollbarHeight and/or verticalScrollbarWidth.
   */
  public var bestMode(get, null):ResizeMode;

  public var horizontalScrollbarHeight(get, null):Int;
  public var verticalScrollbarWidth(get, null):Int;

  #if !FLX_NO_MOUSE
  public var scrollbarThickness:Int = 20;
  #else
  public var scrollbarThickness:Int = 4;
  #end

  private var _state:FlxState;
  private var _horizontalScrollbar:FlxScrollbar;
  private var _verticalScrollbar:FlxScrollbar;
  private var _scrollbarColour:FlxColor;
  private var _resizeModeGoal:ResizeMode;
  private var _hiddenPixelAllowance:Float = 1.0; // don't bother showing scrollbars if this many pixels would go out of view (float weirdness fix)

  /**
   * Creates a specialized FlxCamera that can be added to FlxG.cameras.
   *
   * @param	ViewPort				The area on the screen, in absolute pixels, that will show content.
   * @param	Content					The area (probably off-screen) to be viewed in ViewPort.  Must have a non-zero width and height.
   * @param	Mode					State the goal of your own resizing code, so that the .bestMode property contains an accurate value.
   * @param	ScrollbarThickness		Defaults to 20 for mice and 4 "otherwise" (touch is assumed.)
   * @param	ScrollbarColour			Passed to FlxScrollbar.  ("They say geniuses pick green," so don't change the default unless you're the supergenius we all know you to be.)
   * @param	State					Which state to add the scrollbar(s) to.  If you're in a FlxSubState with its parent paused, pass it in here.
   * @param	MouseWheelMultiplier	How much to multiply mouse wheel deltas by.  Set to 0 to disable mouse wheeling.  Default 100.
   */
  public function new(ViewPort:FlxRect, Content:FlxRect, Mode:ResizeMode, ?ScrollbarThickness:Int = -1, ?ScrollbarColour:FlxColor = FlxColor.LIME,
      ?State:FlxState, ?MouseWheelMultiplier:Int = 100)
  {
    super();

    _state = State;
    if (_state == null) _state = FlxG.state;
    content = Content;
    _resizeModeGoal = Mode; // must be before we set the viewport, because set_viewport uses it; likewise next line
    if (ScrollbarThickness > -1) scrollbarThickness = ScrollbarThickness;
    viewPort = ViewPort;
    _scrollbarColour = ScrollbarColour;

    scroll.x = content.x;
    scroll.y = content.y;

    _verticalScrollbar = new FlxScrollbar(0, 0, scrollbarThickness, 1, FlxScrollbarOrientation.VERTICAL, ScrollbarColour, this, false, _state,
      MouseWheelMultiplier);
    _state.add(_verticalScrollbar);
    _horizontalScrollbar = new FlxScrollbar(0, 0, 1, scrollbarThickness, FlxScrollbarOrientation.HORIZONTAL, ScrollbarColour, this, false, _state,
      MouseWheelMultiplier);
    _state.add(_horizontalScrollbar);

    onResize();
  }

  /**
   * Based on the new viewPort, sets bestMode, horizontalScrollbarHeight, and verticalScrollbarWidth.
   *
   * @param	value	The new viewPort.
   * @return			The same as you passed in, for assignment chaining.
   */
  function set_viewPort(value:FlxRect):FlxRect
  {
    verticalScrollbarWidth = 0;
    horizontalScrollbarHeight = 0; // until otherwise calculated

    #if !FLX_NO_MOUSE
    if (_resizeModeGoal == NONE)
    { // base it directly on content, since this is only used from onResize
      bestMode = NONE;
      if (content.width - value.width > _hiddenPixelAllowance)
      {
        horizontalScrollbarHeight = scrollbarThickness;
      }
      if (content.height - (value.height - horizontalScrollbarHeight) > _hiddenPixelAllowance)
      {
        verticalScrollbarWidth = scrollbarThickness;
        // now, with less width available, do we still fit?
        if (content.width - (value.width - verticalScrollbarWidth) > _hiddenPixelAllowance)
        {
          horizontalScrollbarHeight = scrollbarThickness;
        }
      }
    }
    else
    {
      // base it on the ratio only, because this will be used outside the class to determine new content size
      var contentRatio = content.width / content.height;
      var viewPortRatio = value.width / value.height;
      if (_resizeModeGoal == FIT_HEIGHT)
      {
        if (viewPortRatio >= contentRatio)
        {
          bestMode = FIT_HEIGHT;
          horizontalScrollbarHeight = 0;
        }
        else
        {
          var scrollbarredContentRatio = content.width / (content.height + scrollbarThickness);
          if (viewPortRatio <= scrollbarredContentRatio)
          {
            bestMode = FIT_HEIGHT;
            horizontalScrollbarHeight = scrollbarThickness;
          }
          else
          { // in the twilight zone
            bestMode = FIT_WIDTH;
            horizontalScrollbarHeight = 0;
          }
        }
      }
      else
      { // FIT_WIDTH
        if (viewPortRatio <= contentRatio)
        {
          bestMode = FIT_WIDTH;
          verticalScrollbarWidth = 0;
        }
        else
        {
          var scrollbarredContentRatio = (content.width + scrollbarThickness) / content.height;
          if (viewPortRatio >= scrollbarredContentRatio)
          {
            bestMode = FIT_WIDTH;
            verticalScrollbarWidth = scrollbarThickness;
          }
          else
          { // in the twilight zone
            bestMode = FIT_HEIGHT;
            verticalScrollbarWidth = 0;
          }
        }
      }
    }
    #end
    return viewPort = value;
  }

  /**
   * Assumes that .viewPort has already been set in the parent state's onResize function.
   *
   * This is automatically re-run the moment .visible is set to true, to make sure that the correct scrollbars are visible.
   *
   * During resizing, this is skipped if .visible is false.
   */
  override public function onResize()
  {
    if (!visible) return;
    super.onResize();

    #if !FLX_NO_MOUSE
    if (verticalScrollbarWidth > 0)
    {
      _verticalScrollbar.visible = true;
      if (horizontalScrollbarHeight > 0)
      { // both
        _horizontalScrollbar.visible = true;
        _horizontalScrollbar.width = viewPort.width - verticalScrollbarWidth;
        _verticalScrollbar.height = viewPort.height - horizontalScrollbarHeight;
      }
      else
      { // just vert
        _horizontalScrollbar.visible = false;
        _verticalScrollbar.height = viewPort.height;
      }
    }
    else
    {
      _verticalScrollbar.visible = false;
      if (horizontalScrollbarHeight > 0)
      { // just horiz
        _horizontalScrollbar.visible = true;
        _horizontalScrollbar.width = viewPort.width;
      }
      else
      { // neither
        _horizontalScrollbar.visible = false;
      }
    }
    if (_verticalScrollbar.visible)
    {
      _verticalScrollbar.x = viewPort.right - scrollbarThickness;
      _verticalScrollbar.y = viewPort.y;
    }
    if (_horizontalScrollbar.visible)
    {
      _horizontalScrollbar.x = viewPort.x;
      _horizontalScrollbar.y = viewPort.bottom - scrollbarThickness;
    }
    if (_verticalScrollbar.visible || _horizontalScrollbar.visible)
    {
      _verticalScrollbar.updateViewScroll();
      _horizontalScrollbar.updateViewScroll();
    }
    if (_verticalScrollbar.visible) _verticalScrollbar.draw();
    if (_horizontalScrollbar.visible) _horizontalScrollbar.draw();
    #end
    x = Std.int(viewPort.x);
    y = Std.int(viewPort.y);
    width = Std.int(viewPort.width - verticalScrollbarWidth);
    height = Std.int(viewPort.height - horizontalScrollbarHeight);
  }

  function get_bestMode():ResizeMode
  {
    return bestMode;
  }

  function get_horizontalScrollbarHeight():Int
  {
    return horizontalScrollbarHeight;
  }

  function get_verticalScrollbarWidth():Int
  {
    return verticalScrollbarWidth;
  }

  override public function set_visible(value:Bool):Bool
  {
    super.set_visible(value); // so onResize doesn't return early
    if (value) // if visible
      onResize(); // show only if needed (recalc)
    else
      _horizontalScrollbar.visible = _verticalScrollbar.visible = false; // don't show
    return value;
  }

  override public function destroy()
  {
    for (bar in [_horizontalScrollbar, _verticalScrollbar])
    {
      _state.remove(bar);
      bar.destroy();
    }
    super.destroy();
  }

  function set_content(value:FlxRect):FlxRect
  {
    content = value;
    if (viewPort != null) // not during the constructor, but normally...
      set_viewPort(viewPort); // ...force update
    return content;
  }

  /**
   * Force a redraw of any visible scrollbars.  Call this if you modify the scroll manually, e.g. to force something to be scrolled into view.
   */
  public function redrawBars()
  {
    _horizontalScrollbar.forceRedraw();
    _verticalScrollbar.forceRedraw();
  }
}

// O que tem no esconderijo?
// .........,,,,,,,,*******/////(((((##############################################
// .........,,,,,,,,********//////(((((###########(((((((((((((/((((((((###%%%#####
// ...........,,...,,,,,,,****//////////////////////(((((###############%%%%&%###%#
//   ....,***///(((#########((###%%%%%%%%####%%%%&&&&&&&&%%%%%%%%&&&&&&&%%%%%%%%&#
// .**(((((##%%&&&&&&&%%%%%%&&&&&&&&%%%%%&&&&&&&&&&&&&%&&&&&&&@@@&&&&%%%&&&&&&&&%&#
// ,*/%%&&&&&&&&&&%%%%&&&&&&&&&&&&&&&@@@@@&&&&&&&&&@@@@@@&&&&&&&&&&@@@@&&&&&&&&&&&%
//*/#&@@&&&&&&&%&&&@@@@&&&&&@@@@@@@@@@&&@@@@@@@@@@&&&&&&&&&&@@@@%#/*//********/&&&
////%&@@@&&&&&@@@@@********(#%%%%%%%&&&&&@@%.,.,........&@@@@@@&&&&&&%&&&%(*,,*&&&
//*/(%@@@@@&&@@@@@%***#&@@@@@@@@&#/*,,..............,,,,,,,,,,,,,,,,**/(%&&&%//&&&
// (((((((#((@@@&&&&%%&%%%%%%%&&&&&&%%%%&&@@@&&&&&&&&&&&&&&&&&&&&&%%%%%%%&&&&&&%%%%
// ...,*/#(#@@@&@@&&&&&&&&&&&&%%%%&&&@@@@&&&&&&#####&@@&&&&&&%%%%%%&&&&&%%%%####%(
// ,,,.,,(((&@@/&@@@@@&&%%%%%%&&&&&&&%%%%&&&&(.....,,%@@&%%%%&&&&&&%%%#######%%%%/
// ..,, .,/((&@@//@@&&%%&&&@@@&&&%%%%%%%%%&&%.,,......,/@@@@@&&&&%%%######%%%&&&&//
// ..,,*///((#&%***(&@@@@@&&&%%%%%%##((////,,,,,,...............,,,,,,,,,,,*****%//
// ,**///((((#**/***,,*/,,,,***,..........,,,,,,,,,...........       .....,,,***&&/
//  ..,********(****,,,/@@&%(/*,...       /,,,,,,,,,,,,,,.............,,,,,****&@@
//*  .,,*******(****,,,,,*&&&&&&%%%%%#.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%%%%%((###((
// ,....,*****/*//***,,,,,,,,,*###((((*...,.,,,,,,,,,,,,,,,,,,,,,,,,,,,&&&%#//(##//
// ,,..,..,,**//*****,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,********&@&%#(//*%,,
// (((((##%%%&&&&/*******,*,,,,,********************///((##%%%%&&&&&&&@@@&&%%%#(*,,
// &&&&&%%%%&&&&&&%**********/((#%%%&&%/////////////////***/#%#####%%%%%%#%%%%#(#*,
// %%%######&%%%&&&&@&&&%#((((##%%%%%#####/*/********,,,(#(%#######((((##((%%%#((#%
// %%%%%%%%#%%%%%%%&&&&%%%###(######(((((///(((#############(((((######((((&%%#((((
// ##%&%%&&%#%%%%###%%%%%%#((%%((((((((((((##############(((#####(%#((#(((#@%%%%%%%
// &&%##%&&%####(%@@@@&%(###((#@@%((#%%%###########(((((##(((((%@@((##((##%&&&&&&&&
// @@&&&%%#(#%@@@@@@@@&&%((###(%@@@@@&#((###%#####((((((((#&@@@@@%(##((###&&@@@@@@@
// @@@@&%%*#%&&&@@@@@@&&&%#((###@@@@@@@@@@@@&#((((##&@@@@@@@@@@@@(#%(((###@@@@@@#(/
// @@@@....#%%&&&@@@@@@&%%%%#(##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&(%%%#%%#%@@@@/////
