package notes;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;

class StrumLine extends FlxTypedGroup<FlxBasic>
{
	public var receptors:FlxTypedGroup<UIStaticArrow>;
	public var splashNotes:FlxTypedGroup<NoteSplash>;
	public var notesGroup:FlxTypedGroup<Note>;
	public var holdsGroup:FlxTypedGroup<Note>;
	public var allNotes:FlxTypedGroup<Note>;

	public function new(x:Float = 0, keyAmount:Int = 4 /*, ?parent:StrumLine what is this for */)
	{
		super();

		receptors = new FlxTypedGroup<UIStaticArrow>();
		splashNotes = new FlxTypedGroup<NoteSplash>();
		notesGroup = new FlxTypedGroup<Note>();
		holdsGroup = new FlxTypedGroup<Note>();

		allNotes = new FlxTypedGroup<Note>();

		for (i in 0...keyAmount)
		{
			var staticArrow:UIStaticArrow = new UIStaticArrow(x, 60 + (SaveData.get(DOWN_SCROLL) ? FlxG.height - 150 : 0), i);
			staticArrow.ID = i;

			staticArrow.x -= ((keyAmount / 2) * Note.swagWidth);
			staticArrow.x += (Note.swagWidth * i);
			receptors.add(staticArrow);

			staticArrow.initialX = Math.floor(staticArrow.x);
			staticArrow.initialY = Math.floor(staticArrow.y);
			staticArrow.playAnim('static');

			staticArrow.y -= 20;
			staticArrow.alpha = 0;

			FlxTween.tween(staticArrow, {y: staticArrow.initialY, alpha: staticArrow.setAlpha}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			var splash:NoteSplash = new NoteSplash(100, 100, i);
			splash.alpha = 0.0;
			splashNotes.add(splash);
		}

		add(holdsGroup);
		add(receptors);
		add(notesGroup);
		add(splashNotes);
	}

	public function push(newNote:Note)
	{
		var group = (newNote.isSustainNote ? holdsGroup : notesGroup);
		group.add(newNote);
		allNotes.add(newNote);
		group.sort(FlxSort.byY, SaveData.get(DOWN_SCROLL) ? FlxSort.ASCENDING : FlxSort.DESCENDING);
	}

	// goofy
	public function createSplash(data:Int, note:Note = null)
	{
		var skin:String = "noteSplashes";
		if (PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0)
			skin = PlayState.SONG.splashSkin;

		var hue:Float = SaveData.get(ARROW_HSV)[data % 4][0] / 360;
		var sat:Float = SaveData.get(ARROW_HSV)[data % 4][1] / 100;
		var brt:Float = SaveData.get(ARROW_HSV)[data % 4][2] / 100;

		if (note != null)
		{
			skin = note.noteSplashTexture;
			hue = note.noteSplashHue;
			sat = note.noteSplashSat;
			brt = note.noteSplashBrt;
		}

		var strum:UIStaticArrow = receptors.members[note.noteData];
		splashNotes.members[note.noteData].setupNoteSplash(strum.x, strum.y, data, skin, hue, sat, brt);
		splashNotes.members[note.noteData].playAnim(data);
	}
}
