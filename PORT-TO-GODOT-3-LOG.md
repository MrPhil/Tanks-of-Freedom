# Godot Project Porting Procedure, 2.1.15 to 3.1.1 (WIP)
*see log below for more details*

## Tips
- The right click windows has away to find dependencies and owners (users)  This helps alot untangling some of the pre export steps
- Each major step has it's own branch to help with understanding

## Step-by-step

### Pre-Export
1. Open project in Godot 2.1.5#
1. Open every .xscn and saved as .tscn
  - Tip: use the search filter
1. Deleted all the xscn files
1. Renamed every reference to ".xscn" to ".tscn" in project.
  - I used Notepadd++ to do a "File in files..." with a replace all.
1. Open every .xml tilset's coorisponding .tscn and save as .tres
1. The summar, fall, winter tiles need special treatment
  1. There is a tilset_edit.tscn that is the mother scene for all three .xml tilesets
  1. Export the scene as summer_tiles.tres
  1. Make a copy as fall_tiles.tres and winter_tiles.tres 
  1. Rename the path of the spritesheet depending on the season for each 
1. Deleted all the .xml tilset files
1. Renamed every reference to the .xml tilset to the new .tres in the project.

### Export
1. Used Tools->Export to Godot 3.0 (WIP) into new empty folder
1. Copied folder bin, BuildConfig and Logs from the 2.1.5 folder (maybe?)

### Godot 3.1.1
1. Open project in Godot 3.1.1

### Stablize
1. 

# Porting Log

## May 13, 2019 - MrPhil
1. I reorder the log so the newest post is at the top and the first post is at the bottom.
2. I found the compiler wasn't hitting the cyclic preload problems and instead fixed a bunch of other little things
3. I commented out the call the the translate_me call [TODO]

## May 11th, 2019 - MrPhil
1. Branch Export to Godot 3.1.1
1. Open with Godot 3.1.1, there no errors and mostly .import files were generated.
1. Branch Godot 3.1.1 to Stabilize
1. Open with Godot 3.1.1, run, errors out in the translation script, because add_to_group is an method, I think they are trying to use the tagging system. But, controls like Button and Label that have text don't have a common class ancestor so the interpreter doesn't think add_to_group i a valid call.
1. After reading https://docs.godotengine.org/en/3.1/tutorials/i18n/internationalizing_games.html#converting-keys-to-text I think I just need to pull that script out and Godot 3.1.1's internal transation system will take care of it.
1. So I comment out the code for the script translate_me.gd I'll circle back. [TODO]
1. The next error is Method  I think this means I've hit just normal convertion problems so, I'm going to Follow the migrations notes https://github.com/dploeger/godot-migrationnotes and https://docs.google.com/spreadsheets/u/1/d/1SqLGKpF5B5KzYnY2JzuuP71tsR8WeXZn1imMvHkoKDc/htmlview
  1. I found a couple naked get_node's explosion.gd is the first one.  While trying ot figure out how they are used, exposione is looking for 'AP' and I'm not sure were that node is.  But, in that process of looking I found a scene that won't open maps/workshop.tscn it complains "Unexpected end of file workshop.tscn"
    1. Comparing the file from Pre-Export to the one in Stabilize doesn't reveal anything useful.  The only thing I see is there are three blank lines at the end of the Pre-Export file.  So, I add them to the Stabilize version and the error remains the same.
    1. Looking over the migration notes I find this: "Short singleton names are deprecated: AS, PS, PS2D, SS, SS2D, TS, VS"  I wonder if the AP it was trying to find is a similar kind of singleton? Maybe it stands for AnimationPlayer?	Look at the 2.1 doc doesn't turn up any Ah Ha's
	1. I found AP.  It's a node in hit-points.tscn  It's a Sprite surprisingly
	1.  The fix for the nake get_node calls seems to be because the script don't have an extends.  Unfortunately, sometimes the scripts are used on different kinds of Node (Sprite and Label so far)  so I've been extending Node which seems to be the best common ancestor.  I hope this doesn't mess the system up since it isn't the specific class the script is attached to.  The docs don't seem to talk about this scenero, but this seems to think it's okay https://godotengine.org/qa/10442/tricks-extending-gdscript-between-different-extended-classes 
  1. convert set_flip_h(bool) to flip_h = bool
  1. Hit the maps/workshop.tscn problem again when game_logic.gd tries to load
    1. I turned on logging Project->ProjectSettings->File Logging->Eneable File Logging->Checked/On
	1.  Log say problem is: res://maps/workshop.tscn:10 - Parse Error: Can't create sub resource of type: CanvasItemShaderGraph
	1. This might be because the convert guide says shaders will often need rewriting?
	1. Hmmm... "CanvasItemShaderGraph" doesn't appear in the docs, maybe the exporter didn't handle this resource correctly?
	1. In this blog, they also ran into a shader issue early on: https://steemit.com/games/@cloudif/crash-replace-repeat-porting-resolutiion-to-godot-3
	1. I commented out the shader for now.  I don't know alot about shader's much less Godot way of dealing with them. It looks like a pretty simple shader though, so maybe later I can figure it out.  [TODO]
  1. Remove some strange wrapping code were a lot of Vector2 math is wrapped with Vector2()
  1. I stuble across some documention saying you can call base class method by just starting with a period ex. .baseClassMethod()  I think this might have fixed some of the earler compile problem like the nake get_node.
  1. Tested theory about the base class call method and it did fix the problem in the explosion.gd script!
  1. I've now noticed everytime I open a scene a bunch of changes are made.  I think I should systematically go through and open & save all the scenes (tscn files.)  But, I want to wait until after I get it running.  [TODO]
  1. convet sever Globals.get to ProjectSettings.get
  1. Several objects define a method called connect() that does match the signature of the base/parent class. After searching the 2.1 docs and googling it seems to me this connect method was added in 3.0/3.1 as part of the Signal system improvments.  So, I renamed this meothds to something locally related.
  1. bag_aware.gd is extended by a lot of scripts and they all seem to think they are resources.  So, I'm going to try extending Node.
  1. Running into some cyclic preload problems.

## May 10th, 2019 - MrPhil
1. I think I found the answer, there is a tilset_edit.tscn that is the mother scene for all three .xml tilesets, you simple change export the scene and then change the path of the spritesheet depending on the season!
1. There seems to be something wrong with the units.   When I play my units are sometimes blue and sometimes red??  They seem to change during play too.  Try several maps and all have it going on.  So, I might need to reset master in order to compare the changes and see what might be causing the problem.  This might be a good idea anyways as changes are made to the original master, it can pull them in and thne apply the steps again.
1.  Argggggg.... I seemed to have lost some work in the process of redoing master...
1. I think I found the problem while redoing the xscn to tres step, soldier_blue.tres already existed!  I must have missed that last night and overridden it?!  Should circle back and see how it is in code xml vs tres. [TODO:DONE]
1. So, after having done the xscn to tres step, I find the game has the bug already :(
1.  But, after going back to the solider_blue.xscn/tscn problem, and re-converting it overriding the existing tscn, the bug has gone away!!
1. Completed redoing the Pre-Export step, the game seems to play correctly now.

## May 9th, 2019 - MrPhil
1. I realized it makes more sense to put the log in the master branch, so I moved it.
1. I catelog the tile with no big scene.  Maybe I can make a big scene of all the individual tiles that were export merged.  It looks like each file is make tiles from one sprite sheet specific to the season, see res://assets/terrain/fall/ground.png
1. I did a find all for ".xml" and discover the [season]_tiles are refferenced in a script /scripts/services/tileset_handler.gd and there is a animation_frames.xml mentioned in the .gitignore file??
1. Looking over the sprite sheet, it doesn't look too hard to make a scene file with and then just copy & paste it for each season changing the underliening png.
  
## May 7th, 2019 - MrPhil
1. I went back to my pre export project... I didn't originally make that as branch, but I starting to think make I should make a branch for each main step.  This will make it easier to back step and fix problems found later and also might be useful to someone else trying ot understand the process better.
  - Hmmm.. turns out I did commit some of the Pre-Export work to master, oh well... no biggie.
2. I found that I can easily export the tileset scenes to .tres instead of .xml suing the Godot tool (Scene->Convert To->Tileset).  
3. Then I used the built in Owner tool to find the references and update them to the new .tres files.
  - I found some tilset .xml files that didn't map one-to-one (right it's fall_tiles, summer_tiles, winter_tiles).  I wonder if those are merges of several scenes?

## May 6, 2019 - MrPhil
1. Open project in Godot 2.1.5
2. Open every .xscn and saved as .tscn
3. Deleted all the xscn files
4. Renamed every reference to ".xscn" to ".tscn" in the project.
  - I used Notepadd++ to open every document in the project and then then did a replace all in open documents.
5. Used Tools->Export to Godot 3.0 (WIP) into new empty folder
6. Copied folder bin, BuildConfig and Logs from the 2.1.5 folder
7. Open project in Godot 3.1.1, several errors about missing resources, all seemed to be tilesets
  - My hypothesis is the tileset xml files need a "save as" process like the xscn files