state("Hypnagogia Boundless Dreams") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Hypnagogia Boundless Dreams";
    vars.Helper.LoadSceneManager = true;
    vars.Helper.AlertLoadless();

	settings.Add("NExit", true, "Split on entering main worlds");
	settings.SetToolTip("NExit", "Can be combined with splits for entering the Dream Nexus");

	settings.Add("NEnter", false, "Split on exiting main worlds");
	settings.SetToolTip("NEnter", "Excludes the first Nexus after tutorial. Can be combined with splits for entering main worlds");

	settings.Add("MansionEntry", false, "Split on entering Haunted World's mansion interior");

	settings.Add("HeavenEntry", false, "Split on entering Heaven in Tower World");
	
	settings.Add("Extra", false, "Non-Any% Splits");
	
	settings.CurrentDefaultParent = "Extra";
	
	settings.Add("HellEntry", true, "Split on entering Hell World");
	
	settings.Add("WaterEntry", true, "Split on entering Underwater World");
	
	settings.Add("ForestEntry", true, "Split on entering Forest World");
	
	settings.Add("DesertEntry", true, "Split on entering Desert World");
	
	settings.Add("MazeEntry", true, "Split on entering School World");
	
	settings.Add("CandyEntry", true, "Split on entering Candy World");
	
	settings.Add("ShowcaseEntry", false, "Split on entering Model Showcase from the Dream Hub");
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
	if (current.activeScene == "MainMenu_0" && current.loadingScene == "Scene0_b_IntroStartGame") {
		return true;
	};
}

split
{
	if (!settings["NExit"]) {if (old.activeScene == "Hub_00_b_Intro" && current.activeScene == "Dream_1_Cave") {return true;};}	//on entering Cave no matter what

	else if (old.activeScene.Contains("Hub_0") && current.activeScene.Contains("Dr")) {return settings["NExit"];}	//on entering main worlds from Dream Nexus (not Hub!)
	else if (current.activeScene.Contains("Hub_0") && old.activeScene.Contains("Dr")) {return settings["NEnter"];}	//on entering Dream Nexus from main worlds

	else if (old.activeScene == "Dream_5_Space_Blackhole" && current.activeScene == "Scene2_Intro_Gogi") {return true;}			//on entering Crux cutscene
	else if (old.activeScene == "Scene2_Outro_Gogi" && current.activeScene == "Hub_06_Mansion") {return settings["NEnter"];}	//on leaving Crux

	else if (old.activeScene == "Dream_8_Tower" && current.activeScene == "Dream_9_Heaven") {return settings["HeavenEntry"];}
	else if (old.activeScene.Contains("Dream_6_Mansion_E") && current.activeScene == "Dream_6_Mansion_Interior") {return settings["MansionEntry"];}

	else if (old.activeScene == "Dream_1_Cave" && current.activeScene == "Secret_0_Lava") {return settings["HellEntry"];}
	else if (old.activeScene == "Dream_2_Mist" && current.activeScene == "Secret_4_Water") {return settings["WaterEntry"];}
	else if (old.activeScene == "Dream_3_Bamboo" && current.activeScene == "Secret_4_Forest") {return settings["ForestEntry"];}
	else if (old.activeScene == "Dream_4_Ice" && current.activeScene == "Secret_1_Desert") {return settings["DesertEntry"];}
	else if (old.activeScene == "Dream_6_Mansion_Exterior" && current.activeScene == "Secret_2_Maze") {return settings["MazeEntry"];}
	else if (old.activeScene == "Dream_6_Mansion_Interior" && current.activeScene == "Secret_3_Candy") {return settings["CandyEntry"];}
	else if (old.activeScene.Contains("Dream_3_Bamboo_AfterForest_") && current.activeScene == "LS_Hub_LevelSelect") {return settings["ForestEntry"];}
	else if (old.activeScene == "LS_Hub_LevelSelect" && current.activeScene == "Dream_3_Bamboo") {return settings["ForestEntry"];}
	else if (old.activeScene == "LS_Hub_LevelSelect" && current.activeScene == "Dream_Secret_ShowcaseRoom") {return settings["ShowcaseEntry"];};
}