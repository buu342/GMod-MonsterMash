if MusicList then return end // Prevent autorefresh
 
MusicList = {
    {
        name = "2 SPOOKY 4 U",
        author = "Griffin Lewis",
        song = "sound/music/2Spooky4U.ogg",
    },
    {
        name = "Chopin's Ghost",
        author = "Bert Shefter",
        song = "sound/music/ChopinsGhost.ogg",
    },
    {
        name = "Danse Macabre",
        author = "Camille Saint-saëns",
        song = "sound/music/DanseMacabre.ogg",
    },
    {
        name = "Der Erlkönig",
        author = "Franz Schubert",
        song = "sound/music/erlkonig.ogg",
    },
    {
        name = "Dracula",
        author = "Gene Krupa",
        song = "sound/music/dracula.ogg",
    },
    {
        name = "Goosebumps Theme (Cover)",
        author = "Rhaeide",
        song = "sound/music/Goosebumps.ogg",
    },    
    {
        name = "Grim Grinning Ghosts",
        author = "Xavier Atencio",
        song = "sound/music/GrimGrinningGhosts.ogg",
    },
    {
        name = "Halloween Theme",
        author = "John Carpenter",
        song = "sound/music/Halloween.ogg",
    },
    {
        name = "Haunted House",
        author = "Chris Kevin",
        song = "sound/music/HauntedHouse.ogg",
    },
    {
        name = "Haunted House Boogie",
        author = "Jack Rivers",
        song = "sound/music/hauntedhouseboogie.ogg",
    },
    {
        name = "House on Haunted Hill",
        author = "Frank DeVol",
        song = "sound/music/hauntedhill.ogg",
    },
    {
        name = "Haunted Nights",
        author = "Duke Ellington",
        song = "sound/music/hauntednights.ogg",
    },
    {
        name = "Igor's Party",
        author = "Tony's Monstrosities",
        song = "sound/music/igorsparty.ogg",
    },
    {
        name = "Majin Castle Part 1",
        author = "Goemon Production Team",
        song = "sound/music/MajinCastle1.ogg",
        loopstart = 3.176,
    },
    {
        name = "Majin Castle Part 2",
        author = "Goemon Production Team",
        song = "sound/music/MajinCastle2.ogg",
    },
    {
        name = "Midnight in a Madhouse",
        author = "Chick Webb",
        song = "sound/music/madhouse.ogg",
    },
    {
        name = "Monster Mash",
        author = "Bobby Pickett",
        song = "sound/music/MonsterMash.ogg",
    },
    {
        name = "Monster Shindig",
        author = "Danny Hutton",
        song = "sound/music/monstershindig.ogg",
    },
    {
        name = "More Ghosts 'n Stuff",
        author = "deadmau5",
        song = "sound/music/ghostsnstuff.ogg",
    },
    {
        name = "Move Your Dead Bones",
        author = "Dr. Reanimator",
        song = "sound/music/deadbones.ogg",
    },
    {
        name = "Mysterious Mose",
        author = "Don Neely",
        song = "sound/music/MysteriousMose.ogg",
    },
    {
        name = "Mystic Mansion",
        author = "Naofumi Hataya & Jun Senoue",
        song = "sound/music/mystic.ogg",
    },
    {
        name = "Party Ghouls",
        author = "Mat Clark",
        song = "sound/music/PartyGhoul.ogg",
    },
    {
        name = "Satan Takes a Holiday",
        author = "Tommy Dorsey",
        song = "sound/music/Satan.ogg",
    },
    {
        name = "Scared Stupid Intro Theme",
        author = "Bruce Arnston and Kirby Shelstad",
        song = "sound/music/stupid.ogg",
    },
    {
        name = "Scary Godmother Theme",
        author = "Valhalla Wind Band",
        song = "sound/music/sgm1.ogg",
    },
    {
        name = "Scary Godmother Party Music",
        author = "J.W.",
        song = "sound/music/sgm2.ogg",
    },
    {
        name = "Spooky Scary Skeletons (Eurobeat)",
        author = "Equinox Eurobeat",
        song = "sound/music/Equinox.ogg",
    },
    {
        name = "Skeleton in the Closet",
        author = "Artie Shaw",
        song = "sound/music/skeletoncloset.ogg",
    },
    {
        name = "Spooky Scary Skeletons (Piano)",
        author = "grande1899",
        song = "sound/music/SpookyScaryPiano.ogg",
    },
    {
        name = "The Black Cat",
        author = "Ozzie Nelson and his Orchestra",
        song = "sound/music/blackcat.ogg",
    },
    {
        name = "Terror",
        author = "The Skeltons",
        song = "sound/music/terror.ogg",
    },
    {
        name = "The Goblin Band",
        author = "Glen Gray & The Casa Loma Orchestra",
        song = "sound/music/goblinband.ogg",
    },
    {
        name = "The Great Doot Doot Sneak",
        author = "Julian Cianciolo",
        song = "sound/music/DootDoot.ogg",
    },
    {
        name = "The Little Man Who Wasn't There",
        author = "Glenn Miller",
        song = "sound/music/littleman.ogg",
    },
    {
        name = "The Monster Hop",
        author = "Bert Convy",
        song = "sound/music/monsterhop.ogg",
    },
    {
        name = "The Night Before Halloween",
        author = "Bill Buchanan",
        song = "sound/music/nbh.ogg",
    },
    {
        name = "The Old Devil King",
        author = "Thierry Laurent Caroubi",
        song = "sound/music/devil.ogg",
    },
    {
        name = "Theme from Friday the 13th Part 3",
        author = "Harry Manfredini",
        song = "sound/music/F13Part3.ogg",
    },
    {
        name = "This Is Halloween (Instrumental)",
        author = "Danny Elfman",
        song = "sound/music/nbc.ogg",
    },
    {
        name = "Thriller (Cover)",
        author = "Halloween Sound Machine",
        song = "sound/music/Thriller.ogg",
    },
    {
        name = "White Shivers",
        author = "New Orleans Owls",
        song = "sound/music/shivers.ogg",
    },
    {
        name = "Witch Doctor",
        author = "Ina Ray Hutton",
        song = "sound/music/WitchDoctor.ogg",
    },
}
table.SortByMember(MusicList, "name", true)

for i=1, #MusicList do
    local sng = MusicList[i].song
    sng = string.Replace(sng, "sound/", "")
    util.PrecacheSound(sng)
end