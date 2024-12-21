state("Hypnagogia Boundless Dreams") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Hypnagogia Boundless Dreams";
    vars.Helper.LoadSceneManager = true;
    vars.Helper.AlertLoadless();

	settings.Add("ILMode", false, "IL Mode");
	settings.SetToolTip("ILMode", "Auto-starts and splits for ILs. Probably don't have this turned on for full-game runs! Should be combined with relevant options to split upon beating levels");

	settings.Add("NExit", true, "Split on entering main worlds");
	settings.SetToolTip("NExit", "Can be combined with 'split on finishing main worlds'");

	settings.Add("NEnter", false, "Split on finishing main worlds");
	settings.SetToolTip("NEnter", "Splits when entering the Nexus after a main world. Can be combined with 'split on entering main worlds'");

	settings.Add("MansionEntry", false, "Split on entering Haunted World's mansion interior");

	settings.Add("HeavenEntry", false, "Split on entering Heaven in Tower World");
	
	settings.Add("HeavenEndSplit", true, "Split on loading ending cutscene");
	settings.SetToolTip("HeavenEndSplit", "Subtracts exactly 6 seconds from end time to abide by timing rules, since it splits late");
	
	settings.Add("Extra", false, "Non-Any% Splits");
	
	settings.CurrentDefaultParent = "Extra";
	
	settings.Add("HellEntry", true, "Split on entering Hell World");
	
	settings.Add("WaterEntry", true, "Split on entering Underwater World");
	
	settings.Add("ForestEntry", true, "Split on entering Forest World");
	
	settings.Add("DesertEntry", true, "Split on entering Desert World");
	
	settings.Add("MazeEntry", false, "Split on entering School World");
	settings.Add("MazeExit", true, "Split on finishing School World");
	
	settings.Add("CandyEntry", true, "Split on entering Candy World");
	
	settings.Add("ShowcaseEntry", false, "Split on entering Model Showcase from the Dream Hub");
}

init
{
	vars.currentTime = new TimeSpan(0, 0, 0);
}

update
{
    current.activeScene = vars.Helper.Scenes.Active.Name ?? old.activeScene;
    current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? old.loadingScene;
}

isLoading
{
	if (current.activeScene != current.loadingScene) {
		return true;
	} else {return false;};
}

start
{
	if (current.activeScene == "MainMenu_0" && current.loadingScene == "Scene0_b_IntroStartGame") {return true;}	//for full-game runs
	else if (old.activeScene.Contains("LS") && current.activeScene.Contains("Dr")) {return settings["ILMode"];}		//for main world ILs
	else if (old.activeScene.Contains("Dr") && current.activeScene.Contains("Sec")) {return settings["ILMode"];}	//for secret world ILs
}

split
{
	if (!settings["NExit"] && old.activeScene == "Hub_00_b_Intro" && current.activeScene == "Dream_1_Cave") {return true;}		//on entering Cave no matter what

	else if (old.activeScene.Contains("Hub_0") && current.activeScene.Contains("Dr") && settings["NExit"]) {return true;}		//on entering main worlds from Dream Nexus (not Hub!)

	//on entering following Dream Hub from a level
	else if (settings["NEnter"]) {
		if (old.activeScene.Contains("Dr") && current.activeScene.Contains("Hub_0")) {
			if (Convert.ToInt32(old.activeScene[6]) < Convert.ToInt32(current.activeScene[5])) {return true;}
		}
	}
	else if (current.loadingScene.Contains("LS") && current.activeScene.Contains("Dr") && settings["ILMode"]) {return true;}	//on finishing ILs
	
	else if (current.activeScene == "Dream_9_Heaven" && current.loadingScene == "Scene3_Final_Cutscene_0" && settings["HeavenEndSplit"]) {return true;}	//on ending the run (any% & All Dreams)
	//this will spam split if the player has their splits set up wrong! Might at some point fix this

	else if (old.activeScene == "Dream_5_Space_Blackhole" && current.activeScene == "Scene2_Intro_Gogi") {return true;}					//on entering Crux cutscene
	else if (old.activeScene == "Scene2_Outro_Gogi" && current.activeScene == "Hub_06_Mansion" && settings["NEnter"]) {return true;}	//on leaving Crux

	else if (old.activeScene == "Dream_8_Tower" && current.activeScene == "Dream_9_Heaven" && settings["HeavenEntry"]) {return true;}
	else if (old.activeScene.Contains("Dream_6_Mansion_E") && current.activeScene == "Dream_6_Mansion_Interior" && settings["MansionEntry"]) {return true;}

	else if (old.activeScene == "Dream_1_Cave" && current.activeScene == "Secret_0_Lava" && settings["HellEntry"]) {return true;}
	else if (old.activeScene == "Dream_2_Mist" && current.activeScene == "Secret_4_Water" && settings["WaterEntry"]) {return true;}
	else if (old.activeScene == "Dream_3_Bamboo" && current.activeScene == "Secret_4_Forest" && settings["ForestEntry"]) {return true;}
	else if (old.activeScene == "Dream_4_Ice" && current.activeScene == "Secret_1_Desert" && settings["DesertEntry"]) {return true;}
	else if (old.activeScene == "Dream_6_Mansion_Exterior" && current.activeScene == "Secret_2_Maze" && settings["MazeEntry"]) {return true;}
	else if (old.activeScene == "Secret_2_Maze" && current.activeScene == "Dream_6_Mansion_Exterior_AfterMaze" && settings["MazeEexit"]) {return true;}
	else if (old.activeScene == "Dream_6_Mansion_Interior" && current.activeScene == "Secret_3_Candy" && settings["CandyEntry"]) {return true;}
	else if (old.activeScene.Contains("Dream_3_Bamboo_AfterForest_") && current.activeScene == "LS_Hub_LevelSelect" && settings["ForestEntry"]) {return true;}
	else if (old.activeScene == "LS_Hub_LevelSelect" && current.activeScene == "Dream_3_Bamboo" && settings["ForestEntry"]) {return true;}
	else if (old.activeScene == "LS_Hub_LevelSelect" && current.activeScene == "Dream_Secret_ShowcaseRoom" && settings["ShowcaseEntry"]) {return true;}
}

reset
{
	if (current.activeScene.Contains("Hub_0") && current.loadingScene == "MainMenu_0") {return true;}
	else if (current.activeScene == "Dream_5_Space_Blackhole_Gogi" && current.loadingScene == "MainMenu_0") {return true;}
	else if (current.activeScene == "Dream_9_Heaven" && current.loadingScene == "MainMenu_0") {return true;}
}

gameTime
{
	if (current.activeScene == "Dream_9_Heaven" && current.loadingScene == "Scene3_Final_Cutscene_0") {
		vars.currentTime = timer.CurrentTime.GameTime;
		return vars.currentTime.Subtract(new TimeSpan (0, 0, 6));	//subtract 6 seconds from time on loading ending cutscene
	}
	
	else if (current.loadingScene.Contains("LS") && current.activeScene == "Dream_7_Mall" && settings["ILMode"]) {
		vars.currentTime = timer.CurrentTime.GameTime;
		return vars.currentTime.Subtract(new TimeSpan (0, 0, 8));	//sub 8 from Mall World IL
	}
	
	else if (current.loadingScene.Contains("LS") && current.activeScene == "Dream_9_Heaven" && settings["ILMode"]) {
		vars.currentTime = timer.CurrentTime.GameTime;
		return vars.currentTime.Subtract(new TimeSpan (0, 0, 6));	//sub 6 from Tower IL
	}
	
	else if (current.loadingScene.Contains("LS") && current.activeScene.Contains("Dr") && settings["ILMode"]) {
		vars.currentTime = timer.CurrentTime.GameTime;
		return vars.currentTime.Subtract(new TimeSpan (0, 0, 5));	//sub 5 from generic IL
	}
}