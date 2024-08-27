state("Hypnagogia Boundless Dreams") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Hypnagogia Boundless Dreams";
    vars.Helper.LoadSceneManager = true;
    vars.Helper.AlertLoadless();

	settings.Add("Extra", false, "Split for secret worlds");
	settings.SetToolTip("Extra", "Use for All Achievements and All Dreams");

	settings.Add("on_Extra_Clear", false, "Split on finishing secret worlds", "Extra");
	settings.SetToolTip("on_Extra_Clear", "Splits for clearing Hell, Desert, Candy");

	settings.Add("on_Enter", true, "Split on entering secret worlds", "Extra");
	settings.SetToolTip("on_Enter", "Only matters for Hell, Desert and Candy");
	
	settings.Add("on_Maze", false, "Split on entering School World", "Extra");
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
	if (old.activeScene == "Hub_00_b_Intro" && current.activeScene == "Dream_1_Cave") {return true;}
	else if (old.activeScene == "Hub_02_Mist" && current.activeScene == "Dream_2_Mist") {return true;}
	else if (old.activeScene == "Hub_03_Bamboo" && current.activeScene == "Dream_3_Bamboo") {return true;}
	else if (old.activeScene == "Hub_04_Ice" && current.activeScene == "Dream_4_Ice") {return true;}
	else if (old.activeScene == "Hub_05_Space" && current.activeScene == "Dream_5_Space") {return true;}
	else if (old.activeScene == "Dream_5_Space_Blackhole" && current.activeScene == "Scene2_Intro_Gogi") {return true;}
	else if (old.activeScene == "Hub_06_Mansion" && current.activeScene == "Dream_6_Mansion_Exterior") {return true;}
	else if (old.activeScene == "Hub_07_Mall" && current.activeScene == "Dream_7_Mall") {return true;}
	else if (old.activeScene == "Hub_08_Tower" && current.activeScene == "Dream_8_Tower") {return true;};
	
	if (settings["Extra"]) {
		if (settings["on_Enter"]) {
			if (old.activeScene == "Dream_1_Cave" && current.activeScene == "Secret_0_Lava") {return true;}
			else if (old.activeScene == "Dream_4_Ice" && current.activeScene == "Secret_1_Desert") {return true;}
			else if (old.activeScene == "Dream_6_Mansion_Interior" && current.activeScene == "Secret_3_Candy") {return true;};
		};
		
		if (settings["on_Extra_Clear"]) {
			if (old.activeScene == "Secret_0_Lava" && current.activeScene == "Dream_1_Cave_AfterLava") {return true;}
			else if (old.activeScene == "Secret_1_Desert" && current.activeScene == "Dream_4_Ice_AfterDesert") {return true;}
			else if (old.activeScene == "Secret_3_Candy" && current.activeScene == "Dream_6_Mansion_Interior_AfterCandy") {return true;};
		};
		
		if (settings["on_Maze"]) {
			if (old.activeScene == "Dream_6_Mansion_Exterior" && current.activeScene == "Secret_2_Maze") {return true;};
		};
		
		if (old.activeScene == "Dream_2_Mist" && current.activeScene == "Secret_4_Water") {return true;}
		else if (old.activeScene == "Dream_3_Bamboo" && current.activeScene == "Secret_4_Forest") {return true;}
		else if (old.activeScene == "Secret_2_Maze" && current.activeScene == "Dream_6_Mansion_Exterior_AfterMaze") {return true;}
		else if (old.activeScene == "LS_Hub_LevelSelect" && current.activeScene == "Dream_3_Bamboo") {return true;}
		else if (old.activeScene.Contains("Dream_3_Bamboo_AfterForest_") && current.activeScene == "LS_Hub_LevelSelect") {return true;}
		else if (old.activeScene == "LS_Hub_LevelSelect" && current.activeScene == "Dream_Secret_ShowcaseRoom") {return true;};
	};
}