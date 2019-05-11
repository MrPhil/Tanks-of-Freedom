# Godot Project Porting Procedure, 2.1.15 to 3.1.1 (WIP)
*see log below for more details*

## Tips
- The right click windows has away to find dependencies and owners (users)  This helps alot untangling some of the pre export steps
- Each major step has it's own branch to help with understanding

## Step-by-step

### Pre-Export
1. Open project in Godot 2.1.5#
1. Open every .xscn and saved as .tscn
-- Tip: use the search filter
1. Deleted all the xscn files
1. Renamed every reference to ".xscn" to ".tscn" in project.
-- I used Notepadd++ to do a "File in files..." with a replace all.
1. Open every .xml tilset's coorisponding .tscn and save as .tres
1. The summar, fall, winter tiles need special treatment
1.. There is a tilset_edit.tscn that is the mother scene for all three .xml tilesets
1.. Export the scene as summer_tiles.tres
1.. Make a copy as fall_tiles.tres and winter_tiles.tres 
1.. Rename the path of the spritesheet depending on the season for each 
1. Deleted all the .xml tilset files
1. Renamed every reference to the .xml tilset to the new .tres in the project.

### Export
1. Used Tools->Export to Godot 3.0 (WIP) into new empty folder
1. Copied folder bin, BuildConfig and Logs from the 2.1.5 folder (maybe?)

### Godot 3.1.1
1. Open project in Godot 3.1.1, several errors about missing resources, all seemed to be tilesets

# Porting Log

## May 6, 2019 - MrPhil

1. Open project in Godot 2.1.5
2. Open every .xscn and saved as .tscn
3. Deleted all the xscn files
4. Renamed every reference to ".xscn" to ".tscn" in the project.
-- I used Notepadd++ to open every document in the project and then then did a replace all in open documents.
5. Used Tools->Export to Godot 3.0 (WIP) into new empty folder
6. Copied folder bin, BuildConfig and Logs from the 2.1.5 folder
7. Open project in Godot 3.1.1, several errors about missing resources, all seemed to be tilesets
-- My hypothesis is the tileset xml files need a "save as" process like the xscn files

## May 7th, 2019 - MrPhil

1. I went back to my pre export project... I didn't originally make that as branch, but I starting to think make I should make a branch for each main step.  This will make it easier to back step and fix problems found later and also might be useful to someone else trying ot understand the process better.
-- Hmmm.. turns out I did commit some of the Pre-Export work to master, oh well... no biggie.
2. I found that I can easily export the tileset scenes to .tres instead of .xml suing the Godot tool (Scene->Convert To->Tileset).  
3. Then I used the built in Owner tool to find the references and update them to the new .tres files.
-- I found some tilset .xml files that didn't map one-to-one (right it's fall_tiles, summer_tiles, winter_tiles).  I wonder if those are merges of several scenes?

## May 9th, 2019 - MrPhil
1. I realized it makes more sense to put the log in the master branch, so I moved it.
1. I catelog the tile with no big scene.  Maybe I can make a big scene of all the individual tiles that were export merged.  It looks like each file is make tiles from one sprite sheet specific to the season, see res://assets/terrain/fall/ground.png
1. I did a find all for ".xml" and discover the [season]_tiles are refferenced in a script /scripts/services/tileset_handler.gd and there is a animation_frames.xml mentioned in the .gitignore file??
1. Looking over the sprite sheet, it doesn't look too hard to make a scene file with and then just copy & paste it for each season changing the underliening png.

## May 10th, 2019 - MrPhil
1. I think I found the answer, there is a tilset_edit.tscn that is the mother scene for all three .xml tilesets, you simple change export the scene and then change the path of the spritesheet depending on the season!
1. There seems to be something wrong with the units.   When I play my units are sometimes blue and sometimes red??  They seem to change during play too.  Try several maps and all have it going on.  So, I might need to reset master in order to compare the changes and see what might be causing the problem.  This might be a good idea anyways as changes are made to the original master, it can pull them in and thne apply the steps again.
1.  Argggggg.... I seemed to have lost some work in the process of redoing master...
1. I think I found the problem while redoing the xscn to tres step, soldier_blue.tres already existed!  I must have missed that last night and overridden it?!  Should circle back and see how it is in code xml vs tres.
1. So, after having done the xscn to tres step, I find the game has the bug already :(
1.  But, after going back to the solider_blue.xscn/tscn problem, and re-converting it overriding the existing tscn, the bug has gone away!!
1. Completed redoing the Pre-Export step, the game seems to play correctly now.






