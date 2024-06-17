classdef SnuggleSitters < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        MatchTraitsPanel               matlab.ui.container.Panel
        NextMatchButton                matlab.ui.control.Button
        MatchClientorPetsitter         matlab.ui.control.Label
        MatchGender                    matlab.ui.control.Label
        MatchGenderLabel               matlab.ui.control.Label
        MatchPetSize                   matlab.ui.control.Label
        MatchPetSizeLabel              matlab.ui.control.Label
        MatchAvailability              matlab.ui.control.Label
        MatchAvailabilityLabel         matlab.ui.control.Label
        MatchAge                       matlab.ui.control.Label
        MatchageLabel                  matlab.ui.control.Label
        MatchName                      matlab.ui.control.Label
        MatchnameLabel                 matlab.ui.control.Label
        YourTraitsPanel                matlab.ui.container.Panel
        DisplayClientOrPetSitLabel     matlab.ui.control.Label
        GenderLabel                    matlab.ui.control.Label
        PetSizeLabel                   matlab.ui.control.Label
        AvailabilityLabel              matlab.ui.control.Label
        AgeLabel                       matlab.ui.control.Label
        UsernameLabel                  matlab.ui.control.Label
        displayGender                  matlab.ui.control.Label
        displayPetSize                 matlab.ui.control.Label
        displayAvail                   matlab.ui.control.Label
        displayAge                     matlab.ui.control.Label
        displayUsername                matlab.ui.control.Label
        YourPreferencesPanel           matlab.ui.container.Panel
        GenderLabel_2                  matlab.ui.control.Label
        PetSizeLabel_2                 matlab.ui.control.Label
        AvailabilityLabel_2            matlab.ui.control.Label
        AgeLabel_2                     matlab.ui.control.Label
        displayPrefGender              matlab.ui.control.Label
        displayPrefPetSize             matlab.ui.control.Label
        displayPrefAvail               matlab.ui.control.Label
        displayPrefAge                 matlab.ui.control.Label
        Image                          matlab.ui.control.Image
        FindMatchesButton              matlab.ui.control.Button
        EditDetailsButton              matlab.ui.control.Button
        FinalMatch                     matlab.ui.control.Button
        Tries                          matlab.ui.control.Label
        RegistrationPanel              matlab.ui.container.Panel
        SaveEditsButton                matlab.ui.control.Button
        WhatareyourpreferencesLabel    matlab.ui.control.Label
        FinishRegisterationButton      matlab.ui.control.Button
        PrefferedGenderDropDown        matlab.ui.control.DropDown
        PrefferedGenderDropDownLabel   matlab.ui.control.Label
        PrefferedAvailabilityDropDown  matlab.ui.control.DropDown
        PrefferedAvailabilityDropDownLabel  matlab.ui.control.Label
        PrefferedPetSizeDropDown       matlab.ui.control.DropDown
        PrefferedPetSizeDropDownLabel  matlab.ui.control.Label
        PrefferedAgeEditField          matlab.ui.control.EditField
        PrefferedAgeEditFieldLabel     matlab.ui.control.Label
        IamaPetSitterButton            matlab.ui.control.StateButton
        IamaClientButton               matlab.ui.control.StateButton
        GenderDropDown                 matlab.ui.control.DropDown
        GenderDropDownLabel            matlab.ui.control.Label
        PetSizeDropDown                matlab.ui.control.DropDown
        PetSizeDropDownLabel           matlab.ui.control.Label
        AvailabilityDropDown           matlab.ui.control.DropDown
        AvailabilityDropDownLabel      matlab.ui.control.Label
        UserIDEditField                matlab.ui.control.EditField
        UserIDEditFieldLabel           matlab.ui.control.Label
        AgeEditField                   matlab.ui.control.EditField
        AgeEditFieldLabel              matlab.ui.control.Label
        WhoareyouLabel                 matlab.ui.control.Label
        UsernameEditField              matlab.ui.control.EditField
        UsernameEditFieldLabel         matlab.ui.control.Label
        RegisterButton                 matlab.ui.control.Button
        LogInButton                    matlab.ui.control.Button
    end

    
    properties (Access = public)
        
        userInfo = []; % This line stores the Current User
        CurrPrefs= []; % This line stores current preferences
        matchTries = 0; % This line stores the number of tries to find a match
        idxperbutonclick = 1;%This line is here to allow to match more than 2 times
    end
    
    methods (Access = public)

           
        
        function registerUser(app, username, corp, age, gender, petsize, avail, prefAge, prefGender, prefPetSize, prefAvail)

            %This line first checks if a UserData file exists and loads it
            if exist('userData.mat','file') 
                load('userData.mat','userData');
                load('userPrefs.mat','userPrefs');
                
            else
                %This line then creates the data structure for out userdata
                userData = struct('Username',{},'ClientorPetSit',{},'Age',{},'Gender',{},'PetSize',{},'Avail',{});
                userPrefs = struct('Username',{},'PrefAge',{},'PrefGender',{},'PrefPetSize',{}, 'PrefAvail',{})
            end
             userInfo = struct();
             CurrPrefs = struct();
             
            %This line then checks if username is taken so the same user cannot be taken
            if any(strcmp({userData.Username},username))
                disp('this username is taken')
                return;
            end
            %This is to construct a newUser
            newUser = struct;
            newPref = struct;
            newUser.Username = username;
            newPref.Username = username;
            newUser.ClientorPetSit = corp;
            newUser.Age = age;
            newUser.Gender = gender;
            newUser.PetSize = petsize;
            newUser.Avail = avail;
            newPref.PrefAge = prefAge;
            newPref.PrefGender = prefGender;
            newPref.PrefPetSize = prefPetSize;
            newPref.PrefAvail = prefAvail;

            % This line appends the new user to the userData structure array
            userData(end+1) = newUser;
            userPrefs(end+1) = newPref;

            % This saves the updated userData structure array to a .mat file
            save('userData.mat', 'userData');
            save('userPrefs.mat',"userPrefs")
            app.userInfo = newUser;
            app.CurrPrefs = newPref;
           
            disp('User registered successfully.');
            
        end
        
        function [userInfo,CurrPrefs] = loginUser(app,username)
            %This initializes structs
            userInfo = struct();
            CurrPrefs = struct();

            %While this initializes empty array
            userInfo = [];
            CurrPrefs = []; 
            if exist('userData.mat','file') && exist('userPrefs.mat','file')
                %This loads userdata and its data structure
                load('userData.mat','userData');
                load('userPrefs.mat','userPrefs');
                %This makes an index and uses find for username to see which
                %index it is
                index = find(strcmp({userData.Username},username),1);
                %When the User is found, it extracts info

                if ~isempty(index)
                    userInfo = userData(index);
                    CurrPrefs = userPrefs(index);
                    %This makes all other buttons vanish
                    app.LogInButton.Visible = "off";
                    app.RegisterButton.Visible = "off";
                    app.UsernameEditField.Visible ="off";
                    app.UsernameEditFieldLabel.Visible = "off";
                else
                    
                    warning('User ',username,' not found.')
                    return
                end
            else
                warning('No existing Users.');
            end
        end
        
       
        function [bestMatch, nextBestMatch, message] = findMatches(app, currentUser)
    % This loads the userData and userPrefs structures
    load('userData.mat', 'userData');
    load('userPrefs.mat', 'userPrefs');
    
    % This initializes the scores array
    scores = zeros(length(userData), 1);
    
    % This finds the index of the current user in the userData structure
    currentUserIndex = find(strcmp({userData.Username}, currentUser.Username), 1);
    if isempty(currentUserIndex)
        warning('Current user not found.');
        bestMatch = [];
        nextBestMatch = [];
        message = 'User not found';
        return;
    end
    
    currentUserPrefs = userPrefs(currentUserIndex);
    
    % This is a loop through the userData to calculate scores
    for i = 1:length(userData)
        if i == currentUserIndex || strcmp(userData(i).ClientorPetSit, currentUser.ClientorPetSit)
            scores(i) = -Inf; % This line assigns a low score to skip the current user and similar roles
            continue;
        end
        
        score = 0;
        % These following lines calculate scores based on preferences
        ageDifference = abs(userData(i).Age - currentUserPrefs.PrefAge);
        score = score + (ageDifference <= 5) * 2 + (ageDifference > 5);
        score = score + strcmp(userData(i).Gender, currentUserPrefs.PrefGender);
        score = score + strcmp(userData(i).PetSize, currentUserPrefs.PrefPetSize);
        score = score + strcmp(userData(i).Avail, currentUserPrefs.PrefAvail);
        scores(i) = score;
    end
    
    % This line is here for incrementing the count for each button click
    app.idxperbutonclick = app.idxperbutonclick + 1;
    
    % This sorts scores and get indices, excluding the current user explicitly if needed
    [sortedScores, idx] = sort(scores, 'descend');
    
    % This excludes -Inf scores to remove skipped users, including the current user
    validIdx = idx(sortedScores > -Inf);
    
    if length(validIdx) < app.idxperbutonclick
        bestMatch = [];
        nextBestMatch = [];
        message = 'Ran Out Of Matches, Try Again Later!';
        return;
    end
    
    % Thie line here ensures the idx for the current match button click is within bounds
    matchIdx = min(app.idxperbutonclick, length(validIdx));
    
    % This line here determines best and next best match based on the button click count
    bestMatch = userData(validIdx(1)); % Always the best match
    nextBestMatch = userData(validIdx(matchIdx)); % Varies with each button click
    message = '';

        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)

        end

        % Value changed function: IamaPetSitterButton
        function IamaPetSitterButtonValueChanged(app, event)
            %When Clicked changes the other button
            PetSitvalue = app.IamaPetSitterButton.Value;
            app.IamaClientButton.Value = false;
       
        end

        % Value changed function: IamaClientButton
        function IamaClientButtonValueChanged(app, event)
            %When Clicked changes the other button
            Clientvalue = app.IamaClientButton.Value;
            app.IamaPetSitterButton.Value = false;
         
        end

        % Button pushed function: RegisterButton
        function RegisterButtonPushed(app, event)
            %Makes all other buttons vanish
            app.LogInButton.Visible = "off";
            app.RegisterButton.Visible = "off";
            app.UsernameEditField.Visible ="off";
            app.UsernameEditFieldLabel.Visible = "off";

            %Makes all of the Register Components and Preferences appear
            app.RegistrationPanel.Visible="on";


        end

        % Button pushed function: FinishRegisterationButton
        function FinishRegisterationButtonPushed(app, event)
            %Collects Username
            username = app.UserIDEditField.Value;
            %Checks if client or petsitter buttons were pressed than checks
            %values
            
           

            if app.IamaClientButton.Value == true
                corp = "client";
                app.IamaPetSitterButton.Value == false;
            else
                if app.IamaPetSitterButton.Value == true
                    corp = "PetSitter";
                    app.IamaClientButton.Value == false;
                end
            end
       

            %Converting String to numeric before storing age
            age = str2double(app.AgeEditField.Value);
            gender = app.GenderDropDown.Value;
            petsize = app.PetSizeDropDown.Value;
            avail = app.AvailabilityDropDown.Value;
            prage = str2double(app.PrefferedAgeEditField.Value);
            pgender = app.PrefferedGenderDropDown.Value;
            prpetsize = app.PrefferedPetSizeDropDown.Value;
            pravail = app.PrefferedAvailabilityDropDown.Value;

            %code to display all traits and preferences

            app.registerUser(username,corp,age,gender,petsize,avail,prage,pgender,prpetsize,pravail);

            app.YourTraitsPanel.Visible = "on";
            app.YourPreferencesPanel.Visible ="on";

            app.displayUsername.Text =username;
            app.displayGender.Text = gender;
            app.displayAvail.Text = avail;
            app.displayPetSize.Text = petsize;
            app.displayAge.Text = string(age);
  
            app.displayPrefGender.Text = gender;
            app.displayPrefAvail.Text = avail;
            app.displayPrefPetSize.Text = petsize;
            app.displayPrefAge.Text = string(age);
            
            app.RegistrationPanel.Visible = "off";
            app.EditDetailsButton.Visible = "on";
            app.RegisterButton.Visible = "off";


            app.FindMatchesButton.Visible = "on";

        end

        % Button pushed function: LogInButton
        function LogInButtonPushed(app, event)
            
            %uses log in function 
            username = app.UsernameEditField.Value;
            [userInfo,CurrPrefs] = app.loginUser(username);

            app.userInfo = userInfo;
            app.CurrPrefs = CurrPrefs;%unrecognized function or variable

            app.YourTraitsPanel.Visible = "on";
            app.YourPreferencesPanel.Visible = "on";

            

           
            %Dot indexing not supported for this type for all below

                if ~isempty(app.userInfo)
                    app.displayUsername.Text = app.userInfo.Username;
                    app.displayGender.Text = app.userInfo.Gender;
                    app.displayAvail.Text = app.userInfo.Avail;
                    app.displayPetSize.Text = app.userInfo.PetSize;
                    app.displayAge.Text = num2str(app.userInfo.Age); % his line here uses num2str for numerical values
                    app.DisplayClientOrPetSitLabel.Text = app.userInfo.ClientorPetSit;
                end
                
                if ~isempty(app.CurrPrefs)
                    app.displayPrefGender.Text = app.CurrPrefs.PrefGender;
                    app.displayPrefAvail.Text = app.CurrPrefs.PrefAvail;
                    app.displayPrefPetSize.Text = app.CurrPrefs.PrefPetSize;
                    app.displayPrefAge.Text = num2str(app.CurrPrefs.PrefAge); % his line here uses num2str for numerical values
                end


            app.FindMatchesButton.Visible = "on";
            app.EditDetailsButton.Visible = "on";


            
        end

        % Button pushed function: FindMatchesButton
        function FindMatchesButtonPushed(app, event)
    
    [bestMatch, nextBestMatch, message] = app.findMatches(app.userInfo);
    
    if ~isempty(message)
        % This line here displays the message in a dialog box or as a label text
        uialert(app.UIFigure, message, 'No More Matches');
        return;
    end
    
    app.MatchTraitsPanel.Visible = "on";
    app.MatchClientorPetsitter.Text = string([bestMatch.ClientorPetSit]);
    app.MatchName.Text = string([bestMatch.Username]);
    app.MatchAge.Text = string([bestMatch.Age]);
    app.MatchPetSize.Text = string([bestMatch.PetSize]);
    app.MatchAvailability.Text = string([bestMatch.Avail]);
    app.MatchGender.Text = string([bestMatch.Gender]);
    app.FinalMatch.Visible = 'on'; % This sets visibility to 'on'
    app.matchTries = 0; % This line resets the number of tries

        end

        % Button pushed function: EditDetailsButton
        function EditDetailsButtonPushed(app, event)
            app.EditDetailsButton.Visible = "off";
            app.RegistrationPanel.Visible = "on";
            app.FinishRegisterationButton.Visible = "off";
            app.YourTraitsPanel.Visible = "off";
            app.YourPreferencesPanel.Visible = "off";
            app.RegisterButton.Visible = "off";
            app.UserIDEditField.Editable ="off";
            app.SaveEditsButton.Visible = "on";
        end

        % Button pushed function: SaveEditsButton
        function SaveEditsButtonPushed(app, event)

            % These lines load the userData and userPrefs structures
            load('userData.mat', 'userData');
            load('userPrefs.mat', 'userPrefs');
            
            % These lines determine the role based on button state
            if app.IamaClientButton.Value == true
                corp = "client";
                app.IamaPetSitterButton.Value == false;
            else
                if app.IamaPetSitterButton.Value == true
                    corp = "PetSitter";
                    app.IamaClientButton.Value == false;
                end
            end
            
            % These following lines find the index for the current user in userData
            userIndex = find(strcmp({userData.Username}, app.userInfo.Username));
            if isempty(userIndex)
                disp('User not found.');
                return;
            end
            
            % These lines here update userData and userPrefs with new values from the UI
            userData(userIndex).Age = str2double(app.AgeEditField.Value);
            userData(userIndex).Gender = app.GenderDropDown.Value;
            userData(userIndex).PetSize = app.PetSizeDropDown.Value;
            userData(userIndex).Avail = app.AvailabilityDropDown.Value;
            userData(userIndex).ClientorPetSit = corp; 

            userPrefs(userIndex).PrefAge = str2double(app.PrefferedAgeEditField.Value);
            userPrefs(userIndex).PrefGender = app.PrefferedGenderDropDown.Value;
            userPrefs(userIndex).PrefPetSize = app.PrefferedPetSizeDropDown.Value;
            userPrefs(userIndex).PrefAvail = app.PrefferedAvailabilityDropDown.Value;
            
            % These lines here save the modified structures back to the .mat files
            save('userData.mat', 'userData');
            save('userPrefs.mat', 'userPrefs');
            
            % These lines here update app properties if they are intended to hold the current session's data
            app.userInfo = userData(userIndex);
            app.CurrPrefs = userPrefs(userIndex);

            %These lines here update the display with new information
            if ~isempty(app.userInfo)
                    app.displayUsername.Text = app.userInfo.Username; 
                    app.displayGender.Text = app.userInfo.Gender;
                    app.displayAvail.Text = app.userInfo.Avail;
                    app.displayPetSize.Text = app.userInfo.PetSize;
                    app.displayAge.Text = num2str(app.userInfo.Age); % This line here uses num2str for numerical values
                    app.DisplayClientOrPetSitLabel.Text = app.userInfo.ClientorPetSit;
            end
                
            if ~isempty(app.CurrPrefs)
                    app.displayPrefGender.Text = app.CurrPrefs.PrefGender;
                    app.displayPrefAvail.Text = app.CurrPrefs.PrefAvail;
                    app.displayPrefPetSize.Text = app.CurrPrefs.PrefPetSize;
                    app.displayPrefAge.Text = num2str(app.CurrPrefs.PrefAge); % This line here uses num2str for numerical values
            end

            % This here removes Registration panel

            app.RegistrationPanel.Visible="off";
            app.YourTraitsPanel.Visible = "on";
            app.YourPreferencesPanel.Visible = "on";



            
            disp('User information and preferences updated successfully.');


        end

        % Button pushed function: NextMatchButton
        function NextMatchButtonPushed(app, event)

    [bestMatch, nextBestMatch, message] = app.findMatches(app.userInfo);
    
    if ~isempty(message)
        % This is here to display the message in a dialog box or as a label text
        uialert(app.UIFigure, message, 'No More Matches');
        return;
    end
    
    app.MatchTraitsPanel.Visible = "on";
    app.MatchClientorPetsitter.Text = string([nextBestMatch.ClientorPetSit]);
    app.MatchName.Text = string([nextBestMatch.Username]);
    app.MatchAge.Text = string([nextBestMatch.Age]);
    app.MatchPetSize.Text = string([nextBestMatch.PetSize]);
    app.MatchAvailability.Text = string([nextBestMatch.Avail]);
    app.MatchGender.Text = string([nextBestMatch.Gender]);
    app.matchTries = app.matchTries + 1; % This is here to increment the number of tries

        end

        % Button pushed function: FinalMatch
        function FinalMatchButtonPushed(app, event)

    % This line here displays the number of tries it took to find a match in the label
    app.Tries.Text = sprintf('Tries: %d', app.matchTries);
    app.Tries.Visible = 'on'; % Set visibility to 'on'

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [84 84 826 1033];
            app.UIFigure.Name = 'MATLAB App';

            % Create LogInButton
            app.LogInButton = uibutton(app.UIFigure, 'push');
            app.LogInButton.ButtonPushedFcn = createCallbackFcn(app, @LogInButtonPushed, true);
            app.LogInButton.Position = [241 952 100 23];
            app.LogInButton.Text = 'Log In';

            % Create RegisterButton
            app.RegisterButton = uibutton(app.UIFigure, 'push');
            app.RegisterButton.ButtonPushedFcn = createCallbackFcn(app, @RegisterButtonPushed, true);
            app.RegisterButton.Position = [463 952 100 23];
            app.RegisterButton.Text = 'Register';

            % Create UsernameEditFieldLabel
            app.UsernameEditFieldLabel = uilabel(app.UIFigure);
            app.UsernameEditFieldLabel.HorizontalAlignment = 'right';
            app.UsernameEditFieldLabel.Position = [373 883 60 22];
            app.UsernameEditFieldLabel.Text = 'Username';

            % Create UsernameEditField
            app.UsernameEditField = uieditfield(app.UIFigure, 'text');
            app.UsernameEditField.Position = [353 914 100 22];

            % Create RegistrationPanel
            app.RegistrationPanel = uipanel(app.UIFigure);
            app.RegistrationPanel.Title = 'Registration Panel';
            app.RegistrationPanel.Visible = 'off';
            app.RegistrationPanel.Position = [95 670 637 261];

            % Create WhoareyouLabel
            app.WhoareyouLabel = uilabel(app.RegistrationPanel);
            app.WhoareyouLabel.Position = [122 213 73 22];
            app.WhoareyouLabel.Text = 'Who are you';

            % Create AgeEditFieldLabel
            app.AgeEditFieldLabel = uilabel(app.RegistrationPanel);
            app.AgeEditFieldLabel.HorizontalAlignment = 'right';
            app.AgeEditFieldLabel.Position = [69 183 26 22];
            app.AgeEditFieldLabel.Text = 'Age';

            % Create AgeEditField
            app.AgeEditField = uieditfield(app.RegistrationPanel, 'text');
            app.AgeEditField.Position = [110 183 100 22];

            % Create UserIDEditFieldLabel
            app.UserIDEditFieldLabel = uilabel(app.RegistrationPanel);
            app.UserIDEditFieldLabel.HorizontalAlignment = 'right';
            app.UserIDEditFieldLabel.Position = [53 155 42 22];
            app.UserIDEditFieldLabel.Text = 'UserID';

            % Create UserIDEditField
            app.UserIDEditField = uieditfield(app.RegistrationPanel, 'text');
            app.UserIDEditField.Position = [110 155 100 22];

            % Create AvailabilityDropDownLabel
            app.AvailabilityDropDownLabel = uilabel(app.RegistrationPanel);
            app.AvailabilityDropDownLabel.HorizontalAlignment = 'right';
            app.AvailabilityDropDownLabel.Position = [29 123 65 22];
            app.AvailabilityDropDownLabel.Text = 'Availability ';

            % Create AvailabilityDropDown
            app.AvailabilityDropDown = uidropdown(app.RegistrationPanel);
            app.AvailabilityDropDown.Items = {'1 Days', '2 Days', '3 Days', '4 Days', '5 Days', '6 Days', '7 Days', ''};
            app.AvailabilityDropDown.Position = [109 123 100 22];
            app.AvailabilityDropDown.Value = '1 Days';

            % Create PetSizeDropDownLabel
            app.PetSizeDropDownLabel = uilabel(app.RegistrationPanel);
            app.PetSizeDropDownLabel.HorizontalAlignment = 'right';
            app.PetSizeDropDownLabel.Position = [48 93 50 22];
            app.PetSizeDropDownLabel.Text = 'Pet Size';

            % Create PetSizeDropDown
            app.PetSizeDropDown = uidropdown(app.RegistrationPanel);
            app.PetSizeDropDown.Items = {'Small', 'Medium', 'Large'};
            app.PetSizeDropDown.Position = [109 93 100 22];
            app.PetSizeDropDown.Value = 'Small';

            % Create GenderDropDownLabel
            app.GenderDropDownLabel = uilabel(app.RegistrationPanel);
            app.GenderDropDownLabel.HorizontalAlignment = 'right';
            app.GenderDropDownLabel.Position = [49 63 45 22];
            app.GenderDropDownLabel.Text = 'Gender';

            % Create GenderDropDown
            app.GenderDropDown = uidropdown(app.RegistrationPanel);
            app.GenderDropDown.Items = {'Male', 'Female', 'Non Binary'};
            app.GenderDropDown.Position = [109 63 100 22];
            app.GenderDropDown.Value = 'Male';

            % Create IamaClientButton
            app.IamaClientButton = uibutton(app.RegistrationPanel, 'state');
            app.IamaClientButton.ValueChangedFcn = createCallbackFcn(app, @IamaClientButtonValueChanged, true);
            app.IamaClientButton.Text = 'I am a Client';
            app.IamaClientButton.Position = [12 17 100 23];

            % Create IamaPetSitterButton
            app.IamaPetSitterButton = uibutton(app.RegistrationPanel, 'state');
            app.IamaPetSitterButton.ValueChangedFcn = createCallbackFcn(app, @IamaPetSitterButtonValueChanged, true);
            app.IamaPetSitterButton.Text = 'I am a Pet Sitter';
            app.IamaPetSitterButton.Position = [158 17 101 23];

            % Create PrefferedAgeEditFieldLabel
            app.PrefferedAgeEditFieldLabel = uilabel(app.RegistrationPanel);
            app.PrefferedAgeEditFieldLabel.HorizontalAlignment = 'right';
            app.PrefferedAgeEditFieldLabel.Position = [331 183 78 22];
            app.PrefferedAgeEditFieldLabel.Text = 'Preffered Age';

            % Create PrefferedAgeEditField
            app.PrefferedAgeEditField = uieditfield(app.RegistrationPanel, 'text');
            app.PrefferedAgeEditField.Position = [424 183 100 22];

            % Create PrefferedPetSizeDropDownLabel
            app.PrefferedPetSizeDropDownLabel = uilabel(app.RegistrationPanel);
            app.PrefferedPetSizeDropDownLabel.HorizontalAlignment = 'right';
            app.PrefferedPetSizeDropDownLabel.Position = [308 123 102 22];
            app.PrefferedPetSizeDropDownLabel.Text = 'Preffered Pet Size';

            % Create PrefferedPetSizeDropDown
            app.PrefferedPetSizeDropDown = uidropdown(app.RegistrationPanel);
            app.PrefferedPetSizeDropDown.Items = {'Small', 'Medium', 'Large'};
            app.PrefferedPetSizeDropDown.Position = [425 123 100 22];
            app.PrefferedPetSizeDropDown.Value = 'Small';

            % Create PrefferedAvailabilityDropDownLabel
            app.PrefferedAvailabilityDropDownLabel = uilabel(app.RegistrationPanel);
            app.PrefferedAvailabilityDropDownLabel.HorizontalAlignment = 'right';
            app.PrefferedAvailabilityDropDownLabel.Position = [297 93 113 22];
            app.PrefferedAvailabilityDropDownLabel.Text = 'Preffered Availability';

            % Create PrefferedAvailabilityDropDown
            app.PrefferedAvailabilityDropDown = uidropdown(app.RegistrationPanel);
            app.PrefferedAvailabilityDropDown.Items = {'1 Days', '2 Days', '3 Days', '4 Days', '5 Days', '6 Days', '7 Days', ''};
            app.PrefferedAvailabilityDropDown.Position = [425 93 100 22];
            app.PrefferedAvailabilityDropDown.Value = '1 Days';

            % Create PrefferedGenderDropDownLabel
            app.PrefferedGenderDropDownLabel = uilabel(app.RegistrationPanel);
            app.PrefferedGenderDropDownLabel.HorizontalAlignment = 'right';
            app.PrefferedGenderDropDownLabel.Position = [312 63 98 22];
            app.PrefferedGenderDropDownLabel.Text = 'Preffered Gender';

            % Create PrefferedGenderDropDown
            app.PrefferedGenderDropDown = uidropdown(app.RegistrationPanel);
            app.PrefferedGenderDropDown.Items = {'Male', 'Female', 'Non Bianary'};
            app.PrefferedGenderDropDown.Position = [425 63 100 22];
            app.PrefferedGenderDropDown.Value = 'Male';

            % Create FinishRegisterationButton
            app.FinishRegisterationButton = uibutton(app.RegistrationPanel, 'push');
            app.FinishRegisterationButton.ButtonPushedFcn = createCallbackFcn(app, @FinishRegisterationButtonPushed, true);
            app.FinishRegisterationButton.Position = [393 17 121 23];
            app.FinishRegisterationButton.Text = 'Finish Registeration';

            % Create WhatareyourpreferencesLabel
            app.WhatareyourpreferencesLabel = uilabel(app.RegistrationPanel);
            app.WhatareyourpreferencesLabel.Position = [377 213 147 22];
            app.WhatareyourpreferencesLabel.Text = 'What are your preferences';

            % Create SaveEditsButton
            app.SaveEditsButton = uibutton(app.RegistrationPanel, 'push');
            app.SaveEditsButton.ButtonPushedFcn = createCallbackFcn(app, @SaveEditsButtonPushed, true);
            app.SaveEditsButton.Visible = 'off';
            app.SaveEditsButton.Position = [524 16 100 23];
            app.SaveEditsButton.Text = 'Save Edits';

            % Create Tries
            app.Tries = uilabel(app.UIFigure);
            app.Tries.Visible = 'off';
            app.Tries.Position = [304 71 193 22];
            app.Tries.Text = '';

            % Create FinalMatch
            app.FinalMatch = uibutton(app.UIFigure, 'push');
            app.FinalMatch.ButtonPushedFcn = createCallbackFcn(app, @FinalMatchButtonPushed, true);
            app.FinalMatch.Visible = 'off';
            app.FinalMatch.Position = [345 514 100 23];
            app.FinalMatch.Text = 'Match!';

            % Create EditDetailsButton
            app.EditDetailsButton = uibutton(app.UIFigure, 'push');
            app.EditDetailsButton.ButtonPushedFcn = createCallbackFcn(app, @EditDetailsButtonPushed, true);
            app.EditDetailsButton.Visible = 'off';
            app.EditDetailsButton.Position = [345 618 100 23];
            app.EditDetailsButton.Text = 'Edit Details';

            % Create FindMatchesButton
            app.FindMatchesButton = uibutton(app.UIFigure, 'push');
            app.FindMatchesButton.ButtonPushedFcn = createCallbackFcn(app, @FindMatchesButtonPushed, true);
            app.FindMatchesButton.Visible = 'off';
            app.FindMatchesButton.Position = [345 564 100 23];
            app.FindMatchesButton.Text = 'Find Matches';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [720 922 100 100];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'snugsitimg.png');

            % Create YourPreferencesPanel
            app.YourPreferencesPanel = uipanel(app.UIFigure);
            app.YourPreferencesPanel.Title = 'Your Preferences';
            app.YourPreferencesPanel.Visible = 'off';
            app.YourPreferencesPanel.Position = [455 420 329 236];

            % Create displayPrefAge
            app.displayPrefAge = uilabel(app.YourPreferencesPanel);
            app.displayPrefAge.Position = [87 153 161 22];
            app.displayPrefAge.Text = '';

            % Create displayPrefAvail
            app.displayPrefAvail = uilabel(app.YourPreferencesPanel);
            app.displayPrefAvail.Position = [87 114 161 22];
            app.displayPrefAvail.Text = '';

            % Create displayPrefPetSize
            app.displayPrefPetSize = uilabel(app.YourPreferencesPanel);
            app.displayPrefPetSize.Position = [87 76 161 22];
            app.displayPrefPetSize.Text = '';

            % Create displayPrefGender
            app.displayPrefGender = uilabel(app.YourPreferencesPanel);
            app.displayPrefGender.Position = [87 39 161 22];
            app.displayPrefGender.Text = '';

            % Create AgeLabel_2
            app.AgeLabel_2 = uilabel(app.YourPreferencesPanel);
            app.AgeLabel_2.Position = [13 153 30 22];
            app.AgeLabel_2.Text = 'Age:';

            % Create AvailabilityLabel_2
            app.AvailabilityLabel_2 = uilabel(app.YourPreferencesPanel);
            app.AvailabilityLabel_2.Position = [9 114 65 22];
            app.AvailabilityLabel_2.Text = 'Availability:';

            % Create PetSizeLabel_2
            app.PetSizeLabel_2 = uilabel(app.YourPreferencesPanel);
            app.PetSizeLabel_2.Position = [9 76 53 22];
            app.PetSizeLabel_2.Text = 'Pet Size:';

            % Create GenderLabel_2
            app.GenderLabel_2 = uilabel(app.YourPreferencesPanel);
            app.GenderLabel_2.Position = [9 39 48 22];
            app.GenderLabel_2.Text = 'Gender:';

            % Create YourTraitsPanel
            app.YourTraitsPanel = uipanel(app.UIFigure);
            app.YourTraitsPanel.Title = 'Your Traits';
            app.YourTraitsPanel.Visible = 'off';
            app.YourTraitsPanel.Position = [30 420 304 236];

            % Create displayUsername
            app.displayUsername = uilabel(app.YourTraitsPanel);
            app.displayUsername.Position = [114 186 115 22];
            app.displayUsername.Text = '';

            % Create displayAge
            app.displayAge = uilabel(app.YourTraitsPanel);
            app.displayAge.Position = [108 153 127 22];
            app.displayAge.Text = '';

            % Create displayAvail
            app.displayAvail = uilabel(app.YourTraitsPanel);
            app.displayAvail.Position = [108 114 127 22];
            app.displayAvail.Text = '';

            % Create displayPetSize
            app.displayPetSize = uilabel(app.YourTraitsPanel);
            app.displayPetSize.Position = [109 76 125 22];
            app.displayPetSize.Text = '';

            % Create displayGender
            app.displayGender = uilabel(app.YourTraitsPanel);
            app.displayGender.Position = [114 39 115 22];
            app.displayGender.Text = '';

            % Create UsernameLabel
            app.UsernameLabel = uilabel(app.YourTraitsPanel);
            app.UsernameLabel.Position = [35 186 64 22];
            app.UsernameLabel.Text = 'Username:';

            % Create AgeLabel
            app.AgeLabel = uilabel(app.YourTraitsPanel);
            app.AgeLabel.Position = [35 153 30 22];
            app.AgeLabel.Text = 'Age:';

            % Create AvailabilityLabel
            app.AvailabilityLabel = uilabel(app.YourTraitsPanel);
            app.AvailabilityLabel.Position = [33 114 65 22];
            app.AvailabilityLabel.Text = 'Availability:';

            % Create PetSizeLabel
            app.PetSizeLabel = uilabel(app.YourTraitsPanel);
            app.PetSizeLabel.Position = [33 76 53 22];
            app.PetSizeLabel.Text = 'Pet Size:';

            % Create GenderLabel
            app.GenderLabel = uilabel(app.YourTraitsPanel);
            app.GenderLabel.Position = [35 39 48 22];
            app.GenderLabel.Text = 'Gender:';

            % Create DisplayClientOrPetSitLabel
            app.DisplayClientOrPetSitLabel = uilabel(app.YourTraitsPanel);
            app.DisplayClientOrPetSitLabel.Position = [109 14 77 22];
            app.DisplayClientOrPetSitLabel.Text = '';

            % Create MatchTraitsPanel
            app.MatchTraitsPanel = uipanel(app.UIFigure);
            app.MatchTraitsPanel.Title = 'Match Traits';
            app.MatchTraitsPanel.Visible = 'off';
            app.MatchTraitsPanel.Position = [210 148 386 243];

            % Create MatchnameLabel
            app.MatchnameLabel = uilabel(app.MatchTraitsPanel);
            app.MatchnameLabel.Position = [27 186 74 22];
            app.MatchnameLabel.Text = 'Match name:';

            % Create MatchName
            app.MatchName = uilabel(app.MatchTraitsPanel);
            app.MatchName.Position = [114 186 118 22];
            app.MatchName.Text = '';

            % Create MatchageLabel
            app.MatchageLabel = uilabel(app.MatchTraitsPanel);
            app.MatchageLabel.Position = [29 154 64 22];
            app.MatchageLabel.Text = 'Match age:';

            % Create MatchAge
            app.MatchAge = uilabel(app.MatchTraitsPanel);
            app.MatchAge.Position = [115 154 117 22];
            app.MatchAge.Text = '';

            % Create MatchAvailabilityLabel
            app.MatchAvailabilityLabel = uilabel(app.MatchTraitsPanel);
            app.MatchAvailabilityLabel.Position = [24 111 100 22];
            app.MatchAvailabilityLabel.Text = 'Match Availability:';

            % Create MatchAvailability
            app.MatchAvailability = uilabel(app.MatchTraitsPanel);
            app.MatchAvailability.Position = [136 111 110 22];
            app.MatchAvailability.Text = '';

            % Create MatchPetSizeLabel
            app.MatchPetSizeLabel = uilabel(app.MatchTraitsPanel);
            app.MatchPetSizeLabel.Position = [25 77 89 22];
            app.MatchPetSizeLabel.Text = 'Match Pet Size:';

            % Create MatchPetSize
            app.MatchPetSize = uilabel(app.MatchTraitsPanel);
            app.MatchPetSize.Position = [136 77 97 22];
            app.MatchPetSize.Text = '';

            % Create MatchGenderLabel
            app.MatchGenderLabel = uilabel(app.MatchTraitsPanel);
            app.MatchGenderLabel.Position = [28 45 84 22];
            app.MatchGenderLabel.Text = 'Match Gender:';

            % Create MatchGender
            app.MatchGender = uilabel(app.MatchTraitsPanel);
            app.MatchGender.Position = [136 45 91 22];
            app.MatchGender.Text = '';

            % Create MatchClientorPetsitter
            app.MatchClientorPetsitter = uilabel(app.MatchTraitsPanel);
            app.MatchClientorPetsitter.Position = [24 22 77 22];
            app.MatchClientorPetsitter.Text = '';

            % Create NextMatchButton
            app.NextMatchButton = uibutton(app.MatchTraitsPanel, 'push');
            app.NextMatchButton.ButtonPushedFcn = createCallbackFcn(app, @NextMatchButtonPushed, true);
            app.NextMatchButton.Position = [258 186 100 23];
            app.NextMatchButton.Text = 'Next Match';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SnuggleSitters

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end