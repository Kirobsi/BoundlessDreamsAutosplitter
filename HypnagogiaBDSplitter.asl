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
	
	settings.Add("CruxEntry", true, "Split on finishing Space World and entering the Ethereal Crux");

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
	
	settings.Add("MushReentry", false, "Split on entering Mushroom World from Dream Hub");
	settings.SetToolTip("MushReentry", "For use in All Achievements, since you need to do Mushroom World (and Forest World!) twice");
	
	settings.Add("ShowcaseEntry", false, "Split on entering Model Showcase from the Dream Hub");
	settings.SetToolTip("ShowcaseEntry", "For use in All Achievements. This should be your last split!");
	
	vars.hubNumber = 49;
	vars.dreamNumber = 48;
	vars.endSplit = true;
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
	//on entering main worlds from Dream Nexus (not Hub!)
	if (old.activeScene.Contains("Hub_0") && current.activeScene.Contains("Dr") && settings["NExit"]) {
		if (vars.dreamNumber < Convert.ToInt32(current.activeScene[6])) {
			vars.dreamNumber += 1;
			return true;
		}
	}

	//on entering following Dream Nexus from a level
	else if (old.activeScene.Contains("Dr") && current.activeScene.Contains("Hub_0") && settings["NEnter"]) {
		if (vars.hubNumber < Convert.ToInt32(current.activeScene[5])) {
			vars.hubNumber += 1;
			return true;
		}
	}
	
	if (current.loadingScene.Contains("LS") && current.activeScene.Contains("Dr") && settings["ILMode"]) {return true;}	//on finishing ILs
	
	else if (current.activeScene == "Dream_9_Heaven" && current.loadingScene == "Scene3_Final_Cutscene_0" && settings["HeavenEndSplit"] && vars.endSplit) {
		vars.endSplit = false;	//disable ability to split here again
		return true;			//split on ending the run (any% & All Dreams)
	}

	else if (old.activeScene == "Dream_5_Space_Blackhole" && current.activeScene == "Scene2_Intro_Gogi" && settings["CruxEntry"]) {return true;}	//on entering Crux cutscene
	else if (old.activeScene == "Scene2_Outro_Gogi" && current.activeScene == "Hub_06_Mansion" && settings["NEnter"]) {								//on leaving Crux
		if (vars.hubNumber < Convert.ToInt32(current.activeScene[5])) {
			vars.hubNumber += 1;
			return true;
		}
	}

	else if (old.activeScene == "Dream_8_Tower" && current.activeScene == "Dream_9_Heaven" && settings["HeavenEntry"]) {return true;}						//on entering Heaven
	else if (old.activeScene.Contains("Dream_6_Mansion_E") && current.activeScene == "Dream_6_Mansion_Interior" && settings["MansionEntry"]) {return true;}	//on entering Mansion Interior

	else if (old.activeScene == "Dream_1_Cave" && current.activeScene == "Secret_0_Lava" && settings["HellEntry"]) {return true;}								//on entering Hell World
	else if (old.activeScene == "Dream_2_Mist" && current.activeScene == "Secret_4_Water" && settings["WaterEntry"]) {return true;}								//on entering Underwater World
	else if (old.activeScene == "Dream_3_Bamboo" && current.activeScene == "Secret_4_Forest" && settings["ForestEntry"]) {return true;}							//on entering Forest World
	else if (old.activeScene == "Dream_4_Ice" && current.activeScene == "Secret_1_Desert" && settings["DesertEntry"]) {return true;}							//on entering Desert World
	else if (old.activeScene == "Dream_6_Mansion_Exterior" && current.activeScene == "Secret_2_Maze" && settings["MazeEntry"]) {return true;}					//on entering School World
	else if (old.activeScene == "Secret_2_Maze" && current.activeScene == "Dream_6_Mansion_Exterior_AfterMaze" && settings["MazeEexit"]) {return true;}			//on finishing School World
	else if (old.activeScene == "Dream_6_Mansion_Interior" && current.activeScene == "Secret_3_Candy" && settings["CandyEntry"]) {return true;}					//on entering Candy World
	else if (old.activeScene.Contains("Dream_3_Bamboo_AfterForest_") && current.activeScene == "LS_Hub_LevelSelect" && settings["ForestEntry"]) {return true;}	//end of Forest 2 for All Achievements
	else if (old.activeScene == "LS_Hub_LevelSelect" && current.activeScene == "Dream_3_Bamboo" && settings["MushReentry"]) {return true;}						//on entering Mushroom 2 for All Achievements
	else if (old.activeScene == "LS_Hub_LevelSelect" && current.activeScene == "Dream_Secret_ShowcaseRoom" && settings["ShowcaseEntry"]) {return true;}			//end of AA (enter model showcase)
}


onSplit
{
	
}


reset
{
	if (current.activeScene.Contains("Hub_0") && current.loadingScene == "MainMenu_0") {return true;}						//reset when returning to menu from Dream Nexus,
	else if (current.activeScene == "Dream_5_Space_Blackhole_Gogi" && current.loadingScene == "MainMenu_0") {return true;}	//Crux,
	else if (current.activeScene == "Dream_9_Heaven" && current.loadingScene == "MainMenu_0") {return true;}				//or Heaven
}


onReset
{
	vars.hubNumber = 49;
	vars.dreamNumber = 48;
	vars.endSplit = true;
}


gameTime
{
	if (current.activeScene == "Dream_9_Heaven" && current.loadingScene == "Scene3_Final_Cutscene_0" && vars.endSplit) {
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