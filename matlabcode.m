classdef interfataV1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        Panel_8                         matlab.ui.container.Panel
        ParametriiStaieTextArea         matlab.ui.control.TextArea
        ParametriiStaieTextAreaLabel    matlab.ui.control.Label
        ParametriisimularePanel         matlab.ui.container.Panel
        AnalizaAntenaButton             matlab.ui.control.Button
        EditField_2                     matlab.ui.control.EditField
        ConectareButton                 matlab.ui.control.Button
        StaiedestinaieDropDown          matlab.ui.control.DropDown
        StaiedestinaieDropDownLabel     matlab.ui.control.Label
        StaiesursDropDown               matlab.ui.control.DropDown
        StaiesursDropDownLabel          matlab.ui.control.Label
        ActualizaretimpButton           matlab.ui.control.Button
        SetarestaresimulareLabel        matlab.ui.control.Label
        InterferenButton                matlab.ui.control.Button
        LinkBudgetButton                matlab.ui.control.Button
        AcoperireButton                 matlab.ui.control.Button
        GridLayout2                     matlab.ui.container.GridLayout
        AdaugstaieButton                matlab.ui.control.Button
        Panel_3                         matlab.ui.container.Panel
        AscundeAccesButton              matlab.ui.control.Button
        AcceslasatelitButton            matlab.ui.control.Button
        tergeButton_2                   matlab.ui.control.Button
        AfieazCheckBox_2                matlab.ui.control.CheckBox
        ControlStaieDropDown            matlab.ui.control.DropDown
        ControlStaieDropDownLabel       matlab.ui.control.Label
        Panel_7                         matlab.ui.container.Panel
        DropDown                        matlab.ui.control.DropDown
        DurataEditField                 matlab.ui.control.EditField
        DurataEditFieldLabel            matlab.ui.control.Label
        nchidescenariuButton            matlab.ui.control.Button
        DescarcdateleButton             matlab.ui.control.Button
        PorneteButton                   matlab.ui.control.Button
        OpreteButton                    matlab.ui.control.Button
        RestartButton                   matlab.ui.control.Button
        StatusLabel                     matlab.ui.control.Label
        StartButton                     matlab.ui.control.Button
        nchideButton                    matlab.ui.control.Button
        Panel_4                         matlab.ui.container.Panel
        ParametriiSatelitTextArea       matlab.ui.control.TextArea
        ParametriiSatelitTextAreaLabel  matlab.ui.control.Label
        Panel_2                         matlab.ui.container.Panel
        FotografieazCheckBox            matlab.ui.control.CheckBox
        AfieazConstelaieCheckBox        matlab.ui.control.CheckBox
        ControlConstelaieDropDown       matlab.ui.control.DropDown
        ControlConstelaieDropDownLabel  matlab.ui.control.Label
        tergeButton                     matlab.ui.control.Button
        UrmalasolCheckBox               matlab.ui.control.CheckBox
        AfieazsatelitCheckBox           matlab.ui.control.CheckBox
        ControlSateliiDropDown          matlab.ui.control.DropDown
        ControlSateliiDropDownLabel     matlab.ui.control.Label
        fiierEditField                  matlab.ui.control.EditField
        AdaugFiierTLEButton_2           matlab.ui.control.Button
        ManagerSatelitButton            matlab.ui.control.Button
    end

    properties (Access = private)
        %Proprietati folosite in aplicatie
        nrsat=0;
        v %Fereastra de vizualizare
        sc % Scenariul in care este reprezentat un satelit
        istoricFisiere = {}; % Stochează numele fișierelor încărcate
        ManagerSatelitFigure % Referință pentru fereastra Manager Sateliți
        SimulationName string = "";  % Numele simularii
        dbConnection  % va stoca conexiunea la baza de date
        UserSelectedTime datetime = datetime('today','Format','HH:mm:ss'); % implicit 00:00:00
        satelitiobj = []; % Vectorul de sateliți (de tip Satellite)
        % Structura Constelatii:
        Constelatii = struct( ...
            'Nume', {}, ...                 % Numele constelației
            'AltitudineMedie', {}, ...      % Altitudinea medie a sateliților din constelație
            'NumarSateliti', {}, ...        % Numărul total de sateliți
            'IsLarge', {}, ...              % Flag pentru constelațiile mari (True/False)
            'IsVisible', {}, ...            % Vizibilitatea întregii constelații (True/False)
            'Sateliti', struct(...          % Sateliții din constelație in cazul in care IsLarge e fals
                'Nume', {}, ...             % Numele satelitului
                'Object', {}, ...           % Obiectul satelitului
                'Altitudine', {}, ...       % Altitudinea satelitului [km]
                'Inclinatie', {}, ...       % Înclinația orbitei [grade]
                'OrbitType', {}, ...        % Tipul orbitei (LEO, MEO, GEO, HEO etc.)
                'GroundTrack', {}, ...      % Obiectul pentru ground track-ul satelitului
                'IsVisible', {}, ...        % Vizibilitatea satelitului (True/False)
                'GroundTrackVisible', {}, ...% Vizibilitatea urmei la sol (True/False)
                'VisibilityConstraints', struct(... % Constrângeri de vizibilitate
                    'MinElevation', 10, ...         % Unghi minim de elevație [grade]
                    'MaxRange', {} ...              % Distanța maximă [km] (opțional)
                ), ...
                'TxGimbal', {},...
                'RxGimbal', {},...
                'Emisie', struct( ...   
                    'TxFeederLoss',   {},...  % Pierderi în feederul de transmitere [dB]  
                    'OtherTxLosses',  {},... % Pierderi suplimentare transmisie (cabluri, conectori etc.) [dB]  
                    'TxHPAPower',     {},...  % Putere HPA (High Power Amplifier) la ieșire [dBW]  
                    'TxHPAOBO',       {},...  % Output Back-Off al HPA (pierdere de eficiență) [dB]  
                    'TxAntennaGain',  {} ...  % Câștig antenă transmisie [dBi]  
                ), ...
                'Receptie', struct( ...
                    'InterferenceLoss',{},...  % Pierderi datorate interferențelor externe [dB]  
                    'RxGByT',         {},...  % Factor de zgomot al receptorului (G/T) [dB/K]  
                    'RxFeederLoss',   {},...  % Pierderi în feederul de recepție [dB]  
                    'OtherRxLosses',  {}...   % Pierderi suplimentare recepție (cabluri, conectori etc.) [dB]  
                ), ...
                'OnBoardCamera', {}, ...         % Obiectul camerei de bord
                'FlagCamera', {} ...         % Variabilă booleană: dacă să fie afișată imaginea
            ), ...
             'ObiectSateliti', {}, ...       % salvează obiectele sateliților pentru constelații mari
             'Receiver', {}, ...              % Obiect receptor al constelației
             'Emitter', {} ...                % Obiect emitator al constelației
        );
        GroundStations = struct(...
            'Name', {}, ...
            'Object', {}, ...
            'IsVisible', {}, ...
            'Latitude', {}, ...         % Latitudine [grade]
            'Longitude', {}, ...        % Longitudine [grade]
            'AntennaSelection', {}, ...
            'Links', struct( ...                    % Structură combinată pentru uplink și downlink
                 'Uplink', struct( ...              
                     'FrequencyGHz', {}, ...       
                     'BandwidthMHz', {}, ...       
                     'BitRateMbps', {}, ...         
                     'RequiredEbByNo_dB', {}, ...      
                     'PolarizationMismatch_deg', {}, ... 
                     'ImplementationLoss', {}, ...
                     'AntennaMispointingLoss', {}, ...
                     'RadomeLoss', {} ...
                 ), ...
                 'Downlink', struct( ...
                     'FrequencyGHz', {}, ...       
                     'BandwidthMHz', {}, ...       
                     'BitRateMbps', {}, ...         
                     'RequiredEbByNo_dB', {}, ...      
                     'PolarizationMismatch_deg', {}, ... 
                     'ImplementationLoss', {}, ...
                     'AntennaMispointingLoss', {}, ...
                     'RadomeLoss', {} ...
                 ) ...
            ), ...
            'VisibilityConstraints', struct(...
                'MinElevation', 10, ...       % Unghi minim de elevație [grade]
                'MaxRange', [] ...            % Rază maximă de comunicare [km]
            ), ...
            'AccessLog', struct(...
                'Satellite', {{}}, ...        % Lista sateliților accesați
                'AccessIntervals', {{}}, ...  % Intervalele de timp [start, stop]
                'AccessObject', {{}} ... 
            ), ...
            'Emisie', struct( ...  
                'Altitude',       {},...  % Înălțime emițător (satelit) [m]  
                'TxFeederLoss',   {},...  % Pierderi în feederul de transmitere [dB]  
                'OtherTxLosses',  {},... % Pierderi suplimentare transmisie (cabluri, conectori etc.) [dB]  
                'TxHPAPower',     {},...  % Putere HPA (High Power Amplifier) la ieșire [dBW]  
                'TxHPAOBO',       {},...  % Output Back-Off al HPA (pierdere de eficiență) [dB]  
                'TxAntennaGain',  {} ...  % Câștig antenă transmisie [dBi]  
            ), ...
            'Receptie', struct( ...
                'Altitude',       {},...  % Înălțime receptor (stație de sol) [m]  
                'InterferenceLoss',{},...  % Pierderi datorate interferențelor externe [dB]  
                'RxGByT',         {},...  % Factor de zgomot al receptorului (G/T) [dB/K]  
                'RxFeederLoss',   {},...  % Pierderi în feederul de recepție [dB]  
                'OtherRxLosses',  {}...   % Pierderi suplimentare recepție (cabluri, conectori etc.) [dB]  
            ), ...
           'Meteo', struct( ...                    % Parametrii meteo
                 'Temperature_C', {}, ...          % Temperatură [°C]
                 'Humidity_proc', {}, ...          % Umiditate [%]
                 'Pressure_hPa', {} ...           % Presiune [hPa]
            ), ...
            'Receiver', {}, ...              % Obiect receptor al constelației
            'Emitter', {} ...                % Obiect emitator al constelației
        );

    end    
    methods (Access = private)
        function isRunning = isSimulationRunning(app)
            isRunning = isViewerOpen(app);
        end
        
        function adaugaConstelatie(app, numeConstelatie, sateliti)
            numarSateliti = length(sateliti);
            app.nrsat = app.nrsat + numarSateliti;
            isLarge = numarSateliti > 30; % Prag pentru constelație mare
            altitudini = arrayfun(@(sat) orbitalElements(sat).SemiMajorAxis - 6.3781e6, sateliti);
        
            % Structură goală pentru câmpurile satelitului conform structurii finale
            emptySatelitStruct = struct(...
                'Nume', {}, 'Object', {}, ...
                'Altitudine', {}, 'Inclinatie', {}, ...
                'OrbitType', {}, 'GroundTrack', {}, ...
                'IsVisible', {}, 'GroundTrackVisible', {}, ...
                'VisibilityConstraints', struct('MinElevation', 10, 'MaxRange', {}), ...
                'TxGimbal', {}, ...
                'RxGimbal', {}, ...
                'Emisie', struct( ...
                    'TxFeederLoss', {}, ...
                    'OtherTxLosses', {}, ...
                    'TxHPAPower', {}, ...
                    'TxHPAOBO', {}, ...
                    'TxAntennaGain', {} ...
                ), ...
                'Receptie', struct( ...
                    'InterferenceLoss', {}, ...
                    'RxGByT', {}, ...
                    'RxFeederLoss', {}, ...
                    'OtherRxLosses', {} ...
                ), ...
                'OnBoardCamera', {}, ...
                'FlagCamera', {} ...
            );
        
            if isLarge
                newConstelatie = struct( ...
                    'Nume', numeConstelatie, ...
                    'AltitudineMedie', mean(altitudini) / 1000, ...
                    'NumarSateliti', numarSateliti, ...
                    'IsLarge', true, ...
                    'IsVisible', app.isSimulationRunning(), ...
                    'Sateliti', emptySatelitStruct, ...
                    'ObiectSateliti', {sateliti}, ... 
                    'Receiver', [], ...
                    'Emitter', [] ...
                );
            else
                satelitStructs = arrayfun(@(idx) createSatelitStruct(sateliti(idx), altitudini(idx), app), ...
                                          1:numarSateliti, 'UniformOutput', false);
                newConstelatie = struct( ...
                    'Nume', numeConstelatie, ...
                    'AltitudineMedie', mean(altitudini) / 1000, ...
                    'NumarSateliti', numarSateliti, ...
                    'IsLarge', false, ...
                    'IsVisible', app.isSimulationRunning(), ...
                    'Sateliti', [satelitStructs{:}], ...
                    'ObiectSateliti', [], ...
                    'Receiver', [], ...
                    'Emitter', [] ...
                );
                [sateliti.MarkerColor] = deal(rand(1,3));
            end
        
            if isempty(app.Constelatii)
                app.Constelatii = newConstelatie;
            else
                app.Constelatii = [app.Constelatii, orderfields(newConstelatie, app.Constelatii)];
            end
        
            % Funcția internă actualizată complet conform structurii finale
            function satelitStruct = createSatelitStruct(sat, alt, app)
                visibilityStatus = app.isSimulationRunning();
                satelitStruct = struct( ...
                'Nume', sat.Name, ...
                    'Object', sat, ...
                    'Altitudine', alt / 1000, ...
                    'Inclinatie', rad2deg(orbitalElements(sat).Inclination), ...
                    'OrbitType', app.determineOrbitType(alt), ...
                    'GroundTrack', [], ...
                    'IsVisible', visibilityStatus, ...
                    'GroundTrackVisible', false, ...
                    'VisibilityConstraints', struct('MinElevation', 10, 'MaxRange', []), ...
                    'TxGimbal', [], ...
                    'RxGimbal', [], ...
                    'Emisie', struct( ...
                        'TxFeederLoss', [], ...
                        'OtherTxLosses', [], ...
                        'TxHPAPower', [], ...
                        'TxHPAOBO', [], ...
                        'TxAntennaGain', [] ...
                    ), ...
                    'Receptie', struct( ...
                        'InterferenceLoss', [], ...
                        'RxGByT', [], ...
                        'RxFeederLoss', [], ...
                        'OtherRxLosses', [] ...
                    ), ...
                    'OnBoardCamera', [], ...
                    'FlagCamera', false ...
                );
                
            end
        end

        
        function updateConstellationUI(app)
            % Actualizează checkbox-ul și zona de informații pentru ultima constelație
            if ~isempty(app.Constelatii)
                lastIdx = length(app.Constelatii);
                app.AfieazConstelaieCheckBox.Value = app.Constelatii(lastIdx).IsVisible;
                app.AfieazsatelitCheckBox.Value = app.Constelatii(lastIdx).Sateliti(1).IsVisible;
                afiseazaInformatiiConstelatie(app, app.Constelatii(lastIdx).Nume);
            end
        end

        function isInit = isScenarioInitialized(app)
            % Verificăm dacă scenariul a fost deja inițializat
            isInit = ~isempty(app.sc) && isvalid(app.sc);
        end

       function updateConstellationDropdown(app)
            % Verifică dacă există constelații
            if isempty(app.Constelatii)
                app.ControlConstelaieDropDown.Items = {};
                app.ControlConstelaieDropDown.ItemsData = {};
                app.ControlConstelaieDropDown.Value = {};
                return;
            end
            % Populează Items și ItemsData
            app.ControlConstelaieDropDown.Items = {app.Constelatii.Nume};
            app.ControlConstelaieDropDown.ItemsData = 1:length(app.Constelatii);
            % Selecteaza ultimul element adaugat
            app.ControlConstelaieDropDown.Value = app.ControlConstelaieDropDown.ItemsData(end);
            % Actualizează checkbox-ul 'AfiseazaConstelatie' pentru constelația selectată
            selectedIndex = app.ControlConstelaieDropDown.Value;
            if ~isempty(selectedIndex) && selectedIndex <= length(app.Constelatii)
                app.AfieazConstelaieCheckBox.Value = app.Constelatii(selectedIndex).IsVisible;
            end
       end
        function afiseazaInformatiiConstelatie(app, constelatieNume)
            % Găsește constelația după nume
            idx = find(strcmp({app.Constelatii.Nume}, constelatieNume), 1);
            if isempty(idx)
                error('Constelația "%s" nu există.', constelatieNume);
            end
            constelatie = app.Constelatii(idx);
            infoText = sprintf('Nume: %s\nNumăr Sateliți: %d\nAltitudine Medie: %.2f km\nVizibilitate: %s', ...
                constelatie.Nume, constelatie.NumarSateliti, constelatie.AltitudineMedie, string(constelatie.IsVisible));
            % Afișează informațiile în TextArea
            app.ParametriiSatelitTextArea.Value = splitlines(infoText);
        end
        function updateSatelliteParameters(app)
            % Verifică dacă a fost selectat un satelit în drop-down
            if isempty(app.ControlSateliiDropDown.Value)
                app.ParametriiSatelitTextArea.Value = {'Parametrii Satelit'};
                return;
            end
        
            % Extrage indicii pentru satelitul selectat (format: {idxConst, idxSat})
            satIndices = app.ControlSateliiDropDown.Value;
            idxConst = satIndices{1};
            idxSat   = satIndices{2};
        
            % Verifică validitatea indicilor
            if idxConst > length(app.Constelatii) || idxSat > length(app.Constelatii(idxConst).Sateliti)
                uialert(app.UIFigure, 'Index invalid pentru constelație sau satelit.', 'Eroare');
                return;
            end
        
            % Preia datele satelitului selectat
            satData = app.Constelatii(idxConst).Sateliti(idxSat);
            satObj = satData.Object;
            satName = satData.Nume;

            orbEl = satData.Inclinatie;
            % Dacă satelitul provine din TLE, orbEl.Inclination este deja în grade
            % Dacă nu, condiția de mai jos va face conversia:
            if orbEl < 2*pi
                inclinationDeg = rad2deg(orbEl);
            else
                inclinationDeg = orbEl;
            end

            % Preia timpul de referință introdus de utilizator.
            % Dacă nu a fost setat, folosește implicit 00:00:00
            if isempty(app.UserSelectedTime)
                app.UserSelectedTime = datetime('today','Format','HH:mm:ss');
            end
            selectedTime = app.UserSelectedTime;
            % Pentru afișare, setăm formatul complet (data + oră)
            selectedTime.Format = 'dd-MM-yyyy HH:mm:ss';
            timeStr = char(selectedTime);
            
            % Calculează starea satelitului la momentul selectedTime folosind states
            % se folosește argumentul de timp pentru a obține starea la momentul dorit.
            [pos, vel] = states(satObj, selectedTime, "CoordinateFrame", "inertial");
            velocityKmps = norm(vel) / 1000;
            
            % Calculul altitudinii curente pe baza poziției: 
            % altitudine = norma (poziție) - raza Pământului (în km)
            EarthRadius = 6378e3;  % în metri
            currentAltitudeKm = (norm(pos) - EarthRadius) / 1000;
            
            % Calculează viteza teoretică pentru o orbită circulară la altitudinea curentă
            G = 6.67430e-11;  % m³/kg/s²
            M = 5.972e24;     % kg
            h = currentAltitudeKm * 1000;  % în metri
            theoreticalVelocity = sqrt(G * M / (EarthRadius + h)) / 1000;  % km/s
            
            % Calculează viteza relativă în cadrul ECEF folosind states cu timpul selectedTime
            [~, velECEF] = states(satObj, selectedTime, "CoordinateFrame", "ecef");
            relativeVelocityKmps = norm(velECEF) / 1000;
            
            % Construiește șirul de afișare care include toți parametrii:
            satInfo = sprintf(['Nume: %s\n' ...
                               'Altitudine curentă: %.2f km\n' ...
                               'Înclinatie orbitală: %.2f°\n' ...
                               'Viteza teoretică: %.2f km/s\n' ...
                               'Viteza absolută: %.2f km/s\n' ...
                               'Viteză relativă (ECEF): %.2f km/s\n' ...
                               'Tipul Orbitei: %s\n' ...
                               'Timp: %s'], ...
                               satName, currentAltitudeKm, inclinationDeg, theoreticalVelocity, ...
                               velocityKmps, relativeVelocityKmps, satData.OrbitType, timeStr);
            
            % Actualizează zona de text din interfață
            app.ParametriiSatelitTextArea.Value = splitlines(satInfo);
        end

       function isOpen = isViewerOpen(app)
            % Dacă scenariul nu este inițializat, viewer-ul nu poate fi deschis
            if ~isScenarioInitialized(app)
                 isOpen = false;
                 return;
            end
            % Accesăm proprietatea Viewers a scenariului
            viewers = app.sc.Viewers;
            isOpen = ~isempty(viewers) && isvalid(viewers(1));
        end
        
        function openViewer(app, nume)
            if isempty(app.sc) || ~isvalid(app.sc)
                error('Scenariul nu este inițializat!');
            end
            if app.isViewerOpen()
                updateStatus(app, 'Fereastra de vizualizare este deja deschisă.');
            else
                app.v=satelliteScenarioViewer(app.sc,'Name', nume, "ShowDetails", false);
                updateStatus(app, 'Scenariul de simulare este deschis.');
                
            end
        end
        
        function closeViewer(app)
            if app.isViewerOpen()
                close(app.sc.Viewers(1));
                updateStatus(app, 'Fereastra de vizualizare a fost închisă.');
            else
                uialert(app.UIFigure, 'Nu există nicio fereastră de simulare activă.', 'Avertisment');
            end
        end

        function initializeDatabaseConnection(app)
            % Generează numele bazei de date
            dbName = lower(regexprep(app.SimulationName, '\s+', '_'));
            % Conectare temporară la serverul MySQL
            connTemp = database('', 'admin', '123456789', 'Vendor', 'MySQL', 'Server', 'localhost', 'PortNumber', 3306);
            if ~isopen(connTemp)
                error('Conexiunea la serverul MySQL a eșuat: %s', connTemp.Message);
            end
            
            % Verifică dacă baza de date există
            queryCheck = sprintf('SHOW DATABASES LIKE ''%s'';', dbName);
            curs = exec(connTemp, queryCheck);
            curs = fetch(curs);
            dbList = curs.Data;
            close(curs);
            dbExists = false;
            if iscell(dbList) && ~isempty(dbList)
                val = dbList{1};
                if ~strcmpi(val, 'No Data')
                    dbExists = true;
                end
            end
            
            if dbExists
                fprintf('Baza de date "%s" există deja.\n', dbName);
            else
                % Creează baza de date
                createDBQuery = sprintf('CREATE DATABASE `%s`;', dbName);
                exec(connTemp, createDBQuery);
                fprintf('Baza de date "%s" a fost creată.\n', dbName);
            end
            close(connTemp);
            
            % Conectare finală la baza de date
            app.dbConnection = database(dbName, 'admin', '123456789', 'Vendor', 'MySQL', 'Server', 'localhost', 'PortNumber', 3306);
            if ~isopen(app.dbConnection)
                error('Nu se poate conecta la baza de date "%s": %s', dbName, app.dbConnection.Message);
            end
            
            % Creare tabel pentru logarea acceselor, dacă nu există
            createTableSQL = [...
                'CREATE TABLE IF NOT EXISTS AccessRecords (' ...
                '  RecordID INT AUTO_INCREMENT PRIMARY KEY, ' ...
                '  NodeA VARCHAR(50) NOT NULL, ' ...
                '  NodeB VARCHAR(50) NOT NULL, ' ...
                '  AccessStart TIME NOT NULL, ' ...
                '  AccessEnd TIME NOT NULL' ...
                ');'];
            exec(app.dbConnection, createTableSQL);
         end

        % Actualizează scenariul: se apelează și pentru inițializarea bazei de date
        function initializare_scenariu(app)
             if isempty(app.sc) || ~isvalid(app.sc)
                % Setează parametrii de timp pentru simulare:
                startTime = datetime('today');  % Data de azi la 00:00:00
        
                % Preia valoarea din caseta Durata și unitatea selectată din drop-down
                durationInput = app.DurataEditField.Value;
                unit = app.DropDown.Value;
                
                % Calculăm diferența de timp în funcție de unitate:
                switch unit
                    case 'minute'
                        delta = minutes(str2double(durationInput));
                    case 'ore'
                        delta = hours(str2double(durationInput));
                    case 'ore și minute(hh:mm)'
                        % În acest caz se presupune că input-ul este de forma "hh:mm"
                        parts = sscanf(durationInput, '%d:%d');
                        if numel(parts) == 2
                            delta = hours(parts(1)) + minutes(parts(2));
                        else
                            % Dacă formatul nu este cel așteptat, interpretăm ca ore
                            delta = hours(str2double(durationInput));
                        end
                    case 'zile'
                        delta = days(str2double(durationInput));
                    otherwise
                        % Valoare implicită (de exemplu, 1 oră)
                        delta = hours(1);
                end
                
                stopTime = startTime + delta;
                sampleTime = 60;  % intervalul de eșantionare (în secunde)
                
                % Inițializează scenariul cu startTime, stopTime și sampleTime
                app.sc = satelliteScenario(startTime, stopTime, sampleTime);
                fprintf('Scenariul a fost inițializat cu startTime = %s și stopTime = %s.\n', ...
                    datestr(startTime), datestr(stopTime));
            end
        end

        % Determina tipul orbitei (optimizat)
        function orbitType = determineOrbitType(~, altitude)
            if altitude >= 200e3 && altitude <= 2000e3
                orbitType = "LEO";
            elseif altitude > 2000e3 && altitude <= 35786e3
                orbitType = "MEO";
            elseif abs(altitude - 35786e3) < 500e3
                orbitType = "GEO";
            else
                orbitType = "HEO";
            end
        end
        function validKey = makeValidStructKey(~, key)
            validKey = matlab.lang.makeValidName(key, 'ReplacementStyle', 'delete');
        end
        function updateSatelliteDropdown(app)
            app.ControlSateliiDropDown.Items = {};
            app.ControlSateliiDropDown.ItemsData = {};
            nonLargeConstellations = find(~[app.Constelatii.IsLarge]);
            for idxConst = nonLargeConstellations
                constelatie = app.Constelatii(idxConst);
                for idxSat = 1:length(constelatie.Sateliti)
                    satelitName = constelatie.Sateliti(idxSat).Nume;
                    item = sprintf('%s (%s)', satelitName, constelatie.Nume);
                    app.ControlSateliiDropDown.Items{end+1} = item;
                    app.ControlSateliiDropDown.ItemsData{end+1} = {idxConst, idxSat};
                end
            end
            if ~isempty(app.ControlSateliiDropDown.Items)
                 app.ControlSateliiDropDown.Value = app.ControlSateliiDropDown.ItemsData{1};
                % Update the checkboxes for the first satellite
                selectedIndex = app.ControlSateliiDropDown.Value;
                idxConst = selectedIndex{1};
                idxSat = selectedIndex{2};
                % Validate indices
                if idxConst <= length(app.Constelatii) && idxSat <= length(app.Constelatii(idxConst).Sateliti)
                    selectedSatelit = app.Constelatii(idxConst).Sateliti(idxSat);
                    app.AfieazsatelitCheckBox.Value = selectedSatelit.IsVisible;
                    app.UrmalasolCheckBox.Value = selectedSatelit.GroundTrackVisible;
                end
            end
        end
        function updateGroundStationDropdown(app)
            if isempty(app.GroundStations)
                app.ControlStaieDropDown.Items = {};
                app.ControlStaieDropDown.ItemsData = {};
                app.ControlStaieDropDown.Value = {};
            else
                app.ControlStaieDropDown.Items = {app.GroundStations.Name};
                app.ControlStaieDropDown.ItemsData = num2cell(1:length(app.GroundStations));
                app.ControlStaieDropDown.Value = app.ControlStaieDropDown.ItemsData{end};
            end

            app.AfieazCheckBox_2.Value=app.GroundStations.IsVisible;
        end

        function updateStatus(app, message)
            app.StatusLabel.Text = message;
            drawnow;
        end
        function updateCountsInLabel(app)
            % Numărul de constelații
            numConst = length(app.Constelatii);
    
            % Numărul total de stații de sol
            numStations = length(app.GroundStations);
    
            % Actualizează StatusLabel cu informațiile
            % Poți ajusta textul după preferințe
            app.StatusLabel.Text = sprintf(...
                ['Scenariu actual: \n %d constelații, \n' ...
                 '%d stații de sol, \n' ...
                 '%d sateliți'], ...
                numConst, numStations, app.nrsat);
        end

        function updateStationParameters(app)
            idxStatie = app.ControlStaieDropDown.Value;
            if isempty(idxStatie) || idxStatie > length(app.GroundStations)
                app.ParametriiStaieTextArea.Value = {'Parametri Stație'};
                return;
            end
        
            stationObj = app.GroundStations(idxStatie).Object;
            lat = stationObj.Latitude;   % în grade
            lon = stationObj.Longitude;  % în grade
            stationName = app.GroundStations(idxStatie).Name;
        
            if app.GroundStations(idxStatie).IsVisible
                visStr = 'Da';
            else
                visStr = 'Nu';
            end
            % Preluăm tipul de antenă din structura stației de sol
            if isfield(app.GroundStations, 'AntennaSelection') && ~isempty(app.GroundStations(idxStatie).AntennaSelection)
                antennaStr = app.GroundStations(idxStatie).AntennaSelection;
            else
                antennaStr = 'Nedefinit';
            end
            % Folosește timpul de referință introdus de utilizator
            % Dacă variabila nu este setată, se folosește implicit 00:00:00
            if isempty(app.UserSelectedTime)
                app.UserSelectedTime = datetime('today','Format','HH:mm:ss');
            end
            selectedTime = app.UserSelectedTime;  % este în formatul HH:mm:ss
        
            % Conversia la string pentru afișare (doar ora)
            simTimeStr = char(selectedTime);
        
            orientationStr = 'Niciun satelit selectat pentru orientare.';
            if ~isempty(app.ControlSateliiDropDown.Value)
                % Extrage indicii pentru satelitul selectat {idxConst, idxSat}
                satIndices = app.ControlSateliiDropDown.Value;
                idxConst = satIndices{1};
                idxSat   = satIndices{2};
                satObj = app.Constelatii(idxConst).Sateliti(idxSat).Object;
                satName = app.Constelatii(idxConst).Sateliti(idxSat).Nume;
                % Calculează parametrii AER folosind timpul de referință
                [az, el, range] = aer(stationObj, satObj, selectedTime);
                orientationStr = sprintf('Orientare relativă la satelit "%s":\nAzimut = %.2f°\nElevare = %.2f°\nRază = %.2f km', ...
                                          satName, az, el, range/1000);
            end
        
            infoText = sprintf(['Stație: %s\nLatitudine: %.5f°\nLongitudine: %.5f°\n' ...
                        'Vizibilitate: %s\nTipul antenei: %s\nTimp de referință: %s\n%s'], ...
                        stationName, lat, lon, visStr, antennaStr, simTimeStr, orientationStr);

        
            app.ParametriiStaieTextArea.Value = splitlines(infoText);
        end


        function updateSourceDestinationDropdowns(app)
            % Dacă nu există stații de sol, curățăm dropdown-urile
            if isempty(app.GroundStations)
                app.StaiesursDropDown.Items = {};
                app.StaiesursDropDown.ItemsData = {};
                app.StaiesursDropDown.Value = {};
                
                app.StaiedestinaieDropDown.Items = {};
                app.StaiedestinaieDropDown.ItemsData = {};
                app.StaiedestinaieDropDown.Value = {};
                return;
            end
    
            % Construim lista de nume și o listă de indici (1..N)
            stationNames = {app.GroundStations.Name};
            stationIndices = num2cell(1:length(app.GroundStations));
    
            % Populăm dropdown-ul pentru stația sursă
            app.StaiesursDropDown.Items = stationNames;
            app.StaiesursDropDown.ItemsData = stationIndices;
            
            % Populăm dropdown-ul pentru stația destinație
            app.StaiedestinaieDropDown.Items = stationNames;
            app.StaiedestinaieDropDown.ItemsData = stationIndices;
            
            % Setăm valori implicite (de exemplu, prima stație ca sursă, a doua ca destinație)
            app.StaiesursDropDown.Value = app.StaiesursDropDown.ItemsData{1};
            if length(stationIndices) >= 2
                app.StaiedestinaieDropDown.Value = app.StaiedestinaieDropDown.ItemsData{2};
            else
                % Dacă există o singură stație, setăm și destinația la aceeași
                app.StaiedestinaieDropDown.Value = app.StaiedestinaieDropDown.ItemsData{1};
            end
       end
        
       function intervals = getCoverageIntervals(app, nodeAName, nodeAObj, nodeBName, nodeBObj)
            % Verifică că conexiunea la baza de date este deschisă
            if isempty(app.dbConnection) || ~isopen(app.dbConnection)
                error('Conexiunea la baza de date nu este deschisă!');
            end
        
            % Construiește query-ul de SELECT
            selectSQL = sprintf(['SELECT AccessStart, AccessEnd FROM AccessRecords ' ...
                                 'WHERE NodeA=''%s'' AND NodeB=''%s'' ORDER BY AccessStart;'], ...
                                 nodeAName, nodeBName);
            data = fetch(app.dbConnection, selectSQL);
            
            if ~isempty(data) && iscell(data.Data) && ~strcmpi(data.Data{1}, 'No Data')
                % Datele există – presupunem că sunt stringuri în formatul 'HH:mm:ss'
                Tstart = data.Data(:,1);
                Tend   = data.Data(:,2);
                nRows = size(Tstart,1);
                intervals = NaT(nRows,2);
                for k = 1:nRows
                    s1 = strtrim(Tstart{k});
                    s2 = strtrim(Tend{k});
                    try
                        intervals(k,1) = datetime(s1, 'InputFormat', 'HH:mm:ss', 'Format', 'HH:mm:ss');
                    catch
                        intervals(k,1) = datetime('00:00:00', 'InputFormat', 'HH:mm:ss', 'Format', 'HH:mm:ss');
                    end
                    try
                        intervals(k,2) = datetime(s2, 'InputFormat', 'HH:mm:ss', 'Format', 'HH:mm:ss');
                    catch
                        intervals(k,2) = datetime('00:00:00', 'InputFormat', 'HH:mm:ss', 'Format', 'HH:mm:ss');
                    end
                end
            else
                % Nu există date în DB – calculează intervalele folosind access()
                ac = access(nodeAObj, nodeBObj);
                rawIntervals = accessIntervals(ac);  % obține un array Nx2
                
                % Convertim rawIntervals la datetime, în funcție de tip
                if isnumeric(rawIntervals)
                    rawIntervals = datetime(rawIntervals, 'ConvertFrom', 'datenum');
                elseif isdatetime(rawIntervals)
                    % deja este datetime; nu face nimic
                elseif iscell(rawIntervals)
                    try
                        rawIntervals = cellfun(@(x) datetime(x), rawIntervals);
                    catch ME
                        error('Nu se poate converti rawIntervals din tipul cell: %s', ME.message);
                    end
                elseif istable(rawIntervals)
                    varNames = rawIntervals.Properties.VariableNames;
                    cellStart = table2cell(rawIntervals(:,1));
                    cellEnd   = table2cell(rawIntervals(:,2));
                    nRows = size(cellStart,1);
                    startCol = cell(nRows,1);
                    endCol   = cell(nRows,1);
                    for k = 1:nRows
                        txt = strtrim(cellStart{k});
                        if isempty(txt) || ~contains(txt, ':')
                            txt = '00:00:00';
                        end
                        try
                            startCol{k} = datetime(txt, 'InputFormat', 'HH:mm:ss', 'Format', 'HH:mm:ss');
                        catch
                            startCol{k} = datetime('00:00:00', 'InputFormat', 'HH:mm:ss', 'Format', 'HH:mm:ss');
                        end
                        txt = strtrim(cellEnd{k});
                        if isempty(txt) || ~contains(txt, ':')
                            txt = '00:00:00';
                        end
                        try
                            endCol{k} = datetime(txt, 'InputFormat', 'HH:mm:ss', 'Format', 'HH:mm:ss');
                        catch
                            endCol{k} = datetime('00:00:00', 'InputFormat', 'HH:mm:ss', 'Format', 'HH:mm:ss');
                        end
                    end
                    % Folosim vertcat pentru a concatena celulele
                    rawIntervals = [vertcat(startCol{:}), vertcat(endCol{:})];
                else
                    error('Tipul rawIntervals nu este recunoscut: %s', class(rawIntervals));
                end
                
                % Extrage doar componenta de timp din rawIntervals.
                if isempty(rawIntervals)
                    intervals = NaT(0,2);
                else
                    nRows = size(rawIntervals,1);
                    intervals = NaT(nRows,2);
                    for k = 1:nRows
                        try
                            t1 = timeofday(rawIntervals(k,1));
                        catch
                            t1 = duration(0,0,0);
                        end
                        try
                            t2 = timeofday(rawIntervals(k,2));
                        catch
                            t2 = duration(0,0,0);
                        end
                        % Creăm un datetime pornind de la 'today' (la 00:00) și adăugăm durata
                        intervals(k,1) = datetime('today','Format','HH:mm:ss') + t1;
                        intervals(k,2) = datetime('today','Format','HH:mm:ss') + t2;
                    end
                end
                
                % Inserează intervalele calculate în DB folosind formatul 'HH:mm:ss'
                for k = 1:size(intervals,1)
                    tStartStr = datestr(intervals(k,1), 'HH:mm:ss');
                    tEndStr   = datestr(intervals(k,2), 'HH:mm:ss');
                    insertSQL = sprintf(['INSERT INTO AccessRecords (NodeA, NodeB, AccessStart, AccessEnd) ' ...
                                         'VALUES (''%s'', ''%s'', ''%s'', ''%s'');'], ...
                                         nodeAName, nodeBName, tStartStr, tEndStr);
                    exec(app.dbConnection, insertSQL);
                end
            end
       end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function manager(app)
            
        end

        % Button pushed function: ManagerSatelitButton
        function ManagerSatelitButtonPushed(app, event)
            % Verify if the Manager Sateliti window is already open
            if isempty(app.ManagerSatelitFigure) || ~isgraphics(app.ManagerSatelitFigure)
                % Set window dimensions and position
                screenSize = get(groot, 'ScreenSize');
                windowWidth = 500;  
                windowHeight = 600;  
                windowX = (screenSize(3) - windowWidth) / 2;
                windowY = (screenSize(4) - windowHeight) / 2; 
                % Create the Manager Sateliti window
                fig = uifigure('Name', 'Manager Sateliți', ...
                               'Position', [windowX, windowY, windowWidth, windowHeight]);
                app.ManagerSatelitFigure = fig;
                % Title
                uilabel(fig, 'Text', 'Manager Sateliți', ...
                        'FontSize', 14, 'FontWeight', 'bold', ...
                        'Position', [150, 550, 200, 30]); 
                % Input fields
                editNume = createField(fig, 'Nume Satelit:', 500, 'text', 'Introduceți numele satelitului');
                editAltitudine = createField(fig, 'Altitudine (km):', 460, 'numeric', '200, 36000');
                editExcentricitate = createField(fig, 'Excentricitate:', 420, 'numeric', '0, 1');
                editInclinatie = createField(fig, 'Înclinație (°):', 380, 'numeric', '0, 180');
                editRAAN = createField(fig, 'RAAN (°):', 340, 'numeric', '0, 360');
                editArgument = createField(fig, 'Argumentul Perigeului (°):', 300, 'numeric', '0, 360');
                editAnomalie = createField(fig, 'Anomalia Adevărată (°):', 260, 'numeric', '0, 360');
        
                % Display area for validated parameters
                paramDisplay = uitextarea(fig, 'Position', [50, 100, 400, 100], ...
                                          'Editable', 'off', ...
                                          'Value', {'Aici vor apărea valorile validate.'});
        
                % Button to add satellite
                uibutton(fig, 'push', 'Text', 'Adaugă Satelitul', ...
                    'Position', [170, 50, 150, 30], ...
                    'ButtonPushedFcn', @(~, ~) adaugaSatelitCallback());
        
            else
                % Bring the existing window to the front
                figure(app.ManagerSatelitFigure);
            end
        
            % Callback for adding a satellite
            function adaugaSatelitCallback()
                % Verifică dacă scenariul a fost inițializat
                if ~app.isScenarioInitialized() || ~isvalid(app.sc)
                    uialert(app.UIFigure, 'Scenariul nu este inițializat. Apăsați butonul "Start" pentru a inițializa simularea.', 'Eroare');
                    return;
                end
                % Validate input values
                if ~validateNumeric(editAltitudine, 200, 36000) || ...
                   ~validateNumeric(editExcentricitate, 0, 1) || ...
                   ~validateNumeric(editInclinatie, 0, 180) || ...
                   ~validateNumeric(editRAAN, 0, 360) || ...
                   ~validateNumeric(editArgument, 0, 360) || ...
                   ~validateNumeric(editAnomalie, 0, 360)
                    return;
                end
                % Initialize or update the constellation
                idxConstelatie = find(strcmp({app.Constelatii.Nume}, 'Constelatie_Personalizata'), 1);
                if isempty(idxConstelatie)
                    % Creează un array de structuri gol, cu câmpurile necesare
                    emptySatStruct = struct( ...
                        'Nume',{}, 'Object',{}, 'Altitudine',{}, 'Inclinatie',{}, ...
                        'OrbitType',{}, 'GroundTrack',{}, 'IsVisible',{}, ...
                        'GroundTrackVisible',{}, ...
                        'VisibilityConstraints', struct('MinElevation',10, 'MaxRange',{}), ...
                        'TxGimbal', {}, ...
                        'RxGimbal', {}, ...
                        'Emisie', struct( ...
                            'TxFeederLoss', {}, ...
                            'OtherTxLosses', {}, ...
                            'TxHPAPower', {}, ...
                            'TxHPAOBO', {}, ...
                            'TxAntennaGain', {} ...
                        ), ...
                        'Receptie', struct( ...
                            'InterferenceLoss', {}, ...
                            'RxGByT', {}, ...
                            'RxFeederLoss', {}, ...
                            'OtherRxLosses', {} ...
                        ), ...
                        'OnBoardCamera', {}, ...
                        'FlagCamera', {} ...
                    );
                    app.Constelatii(end+1) = struct( ...
                        'Nume', 'Constelatie_Personalizata', ...
                        'AltitudineMedie', 0, ...
                        'NumarSateliti', 0, ...
                        'IsLarge', false, ...
                        'IsVisible', app.isSimulationRunning(), ...
                        'Sateliti', emptySatStruct, ...
                        'ObiectSateliti', [], ...
                        'Receiver', [], ...
                        'Emitter', [] ...
                    );
                    idxConstelatie = length(app.Constelatii);
                end
                % Prepare satellite orbital parameters
                razaPamantului = 6371e3; % în metri
                altitudine = editAltitudine.Value * 1e3; % Altitude in meters
                eccentricity = editExcentricitate.Value;
                inclination = editInclinatie.Value; 
                RAAN = editRAAN.Value; 
                argumentOfPerigee = editArgument.Value; 
                trueAnomaly = editAnomalie.Value; 
                % Calculează perigeul (r_p)
                r_p = altitudine + razaPamantului;
                % Verificare: orbită circulară sau eliptică
                if eccentricity > 1
                    semiMajorAxis = r_p; % orbită circulară
                else
                    % orbită eliptică – calculează axa mare
                    semiMajorAxis = r_p / (1 - eccentricity);
                
                    % Verificare de siguranță: apogeul să nu fie sub Pământ
                    r_a = semiMajorAxis * (1 + eccentricity);
                    if r_a < razaPamantului
                        errordlg("Parametrii introduși generează o orbită care intersectează Pământul. Crește altitudinea sau scade excentricitatea.", "Eroare");
                        return;
                    end
                end
                try
                    % Create satellite using the satelliteScenario object
                    satelit = satellite(app.sc, ...
                                        semiMajorAxis, ...
                                        eccentricity, ...
                                        inclination, ...
                                        RAAN, ...
                                        argumentOfPerigee, ...
                                        trueAnomaly, ...
                                        'Name', editNume.Value,...
                                        "OrbitPropagator","two-body-keplerian");
                    app.nrsat=app.nrsat+1;
                    % Add satellite to constellation
                    satelitStruct = createSatelitStruct(satelit, altitudine, app);
                    app.Constelatii(idxConstelatie).Sateliti(end+1) = satelitStruct;
                    % Update constellation information
                    app.Constelatii(idxConstelatie).AltitudineMedie = ...
                        mean([app.Constelatii(idxConstelatie).Sateliti.Altitudine]);
                    app.Constelatii(idxConstelatie).NumarSateliti = ...
                        length(app.Constelatii(idxConstelatie).Sateliti);
                    app.Constelatii(idxConstelatie).IsLarge = ...
                        app.Constelatii(idxConstelatie).NumarSateliti > 30;
                    afiseazaInformatiiConstelatie(app,app.Constelatii(idxConstelatie).Nume);
                    % Update dropdowns
                    updateConstellationDropdown(app);
                    updateSatelliteDropdown(app);
                    % Display validated parameter values
                    paramText = sprintf(['Nume: %s\nAltitudine: %.2f km\nExcentricitate: %.2f\n' ...
                                          'Înclinație: %.2f°\nRAAN: %.2f°\nArgument: %.2f°\nAnomalie: %.2f°'], ...
                                          editNume.Value, editAltitudine.Value, ...
                                          editExcentricitate.Value, rad2deg(inclination), ...
                                          rad2deg(RAAN), rad2deg(argumentOfPerigee), rad2deg(trueAnomaly));
                    paramDisplay.Value = splitlines(paramText);
                    updateCountsInLabel(app);
                    % Success message
                    uialert(fig, sprintf('Satelitul "%s" a fost adăugat cu succes!', editNume.Value), 'Succes');
                catch ME
                    % Display error if satellite creation fails
                    uialert(fig, sprintf('Eroare la adăugarea satelitului: %s Încearcă ale date', ME.message), 'Eroare');
                end
                app.satelitiobj=[app.satelitiobj, satelit];
                % Helper function to create a satellite struct
                function satelitStruct = createSatelitStruct(sat, alt, app)
                    % Determină starea de vizibilitate din simulare
                    visibilityStatus = app.isSimulationRunning();
                    % Creează structura pentru satelit
                    satelitStruct = struct( ...
                        'Nume', sat.Name, ...
                        'Object', sat, ...
                        'Altitudine', alt / 1000, ... % în km
                        'Inclinatie', rad2deg(orbitalElements(sat).Inclination), ...
                        'OrbitType', app.determineOrbitType(alt), ...
                        'GroundTrack', [], ...
                        'IsVisible', visibilityStatus, ...
                        'GroundTrackVisible', false, ...
                        'VisibilityConstraints', struct('MinElevation', 10, 'MaxRange', []), ...
                        'TxGimbal', [], ...
                        'RxGimbal', [], ...
                        'Emisie', struct( ...
                            'TxFeederLoss', [], ...
                            'OtherTxLosses', [], ...
                            'TxHPAPower', [], ...
                            'TxHPAOBO', [], ...
                            'TxAntennaGain', [] ...
                        ), ...
                        'Receptie', struct( ...
                            'InterferenceLoss', [], ...
                            'RxGByT', [], ...
                            'RxFeederLoss', [], ...
                            'OtherRxLosses', [] ...
                        ), ...
                        'OnBoardCamera', [], ...
                        'FlagCamera', false ...
                    );
                    % Dacă doriți să inițializați camera la bord
                    % satelitStruct.OnBoardCamera = conicalSensor(sat, "Name", [sat.Name " Camera"], "MaxViewAngle", 90);
                end
            end

             % Funcție de validare numerică
                function isValid = validateNumeric(field, minVal, maxVal)
    
                    if field.Value < minVal || field.Value > maxVal
                        uialert(fig, sprintf('Valoarea din "%s" trebuie să fie între %.2f și %.2f.', ...
                            field.Tag, minVal, maxVal), 'Eroare');
                        isValid = false;
                    else
                        isValid = true;
                    end
                end
                % Funcție pentru crearea câmpurilor de intrare
                function field = createField(fig, labelText, posY, fieldType, limits)
                    uilabel(fig, 'Text', labelText, 'Position', [50, posY, 150, 22]);
                    switch fieldType
                        case 'text'
                            field = uieditfield(fig, 'text', 'Position', [220, posY, 200, 25]);
                        case 'numeric'
                            limitVals = str2num(limits); %#ok<ST2NM>
                            field = uieditfield(fig, 'numeric', ...
                                'Position', [220, posY, 200, 25], ...
                                'Limits', limitVals);
                    end
                end
        end

        % Callback function
        function ManagerStaiidesolButtonPushed(app, event)

        end

        % Button pushed function: AdaugFiierTLEButton_2
        function AdaugFiierTLEButton_2Pushed(app, event)
             % Verifică dacă scenariul a fost inițializat
            if ~app.isScenarioInitialized() || ~isvalid(app.sc)
                uialert(app.UIFigure, ...
                    'Scenariul nu este inițializat. Apăsați butonul "Start" pentru a inițializa simularea.', ...
                    'Eroare');
                return;
            end
            
            % Selectează fișier TLE
            [file, path] = uigetfile('*.tle', 'Selectați un fișier TLE');
            if file ~= 0
                % Creăm dialogul de progres (valoare determinată, cu posibilitate de anulare)
                dlg = uiprogressdlg(app.UIFigure, ...
                    'Title', 'Procesare TLE', ...
                    'Message', 'Se încarcă fișierul...', ...
                    'Indeterminate', 'off', ...
                    'Cancelable', 'on');
                dlg.Value = 0;
                
                try
                    fullPath = fullfile(path, file);
                    
                    % Verifică și inițializează mapa istoric
                    if isempty(app.istoricFisiere) || ~isa(app.istoricFisiere, 'containers.Map')
                        app.istoricFisiere = containers.Map();
                    end
                    
                    % Verifică dacă fișierul a fost deja încărcat
                    if isKey(app.istoricFisiere, file)
                        close(dlg);
                        uialert(app.UIFigure, ...
                            'Acest fișier a fost deja încărcat anterior.', ...
                            'Avertisment');
                        return;
                    end
                    
                    % Actualizare progres
                    dlg.Value = 0.2;
                    dlg.Message = 'Se citesc datele...';
                    pause(0.1);  % Permite UI-ului să se actualizeze
                    
                    % Setează câmpul fiierEditField cu numele fișierului
                    app.fiierEditField.Value = file;
                    
                    % Construiește numele constelației
                    numeConstelatie = replace(file, {'_TLE', '.tle'}, '');
                    
                    % Adaugă sateliții din fișier (OrbitPropagator = two-body-keplerian)
                    sateliti = satellite(app.sc, fullPath, ...
                                         "OrbitPropagator", "two-body-keplerian");
                    app.satelitiobj=[app.satelitiobj, sateliti];
                    % Actualizare progres
                    dlg.Value = 0.5;
                    dlg.Message = 'Adăugare constelație în structură...';
                    pause(0.1);

                    validnumeConstelatie = app.makeValidStructKey(numeConstelatie);
                    
                    % Utilizează funcția adaugaConstelatie pentru a structura și adăuga sateliții
                    adaugaConstelatie(app, validnumeConstelatie, sateliti);
                    
                    % Actualizare progres
                    dlg.Value = 0.7;
                    dlg.Message = 'Actualizare interfață...';
                    pause(0.1);
                    disp({"NUME ESTE %S",app.Constelatii.Nume});
                    % Actualizează dropdown-urile
                    updateConstellationDropdown(app);
                    updateSatelliteDropdown(app);
                    
                    % Afișează informații despre noua constelație
                    afiseazaInformatiiConstelatie(app, validnumeConstelatie);
                    
                    % Actualizează etichetele cu numărul de constelații și sateliți
                    updateCountsInLabel(app);
                    
                    % Aproape de final
                    dlg.Value = 0.9;
                    dlg.Message = 'Finalizare...';
                    pause(0.1);
                    
                    % Mesaj de succes
                    uialert(app.UIFigure, ...
                        sprintf('Constelația "%s" a fost adăugată cu succes!', numeConstelatie), ...
                        'Succes');
                    
                    % Adaugă fișierul în mapa istoric
                    app.istoricFisiere(file) = fullPath;
                    
                    % Setăm progresul la 100% și închidem dialogul
                    dlg.Value = 1;
                    close(dlg);
                    
                catch ME
                    % În caz de eroare, închidem dialogul și retrimitem eroarea
                    close(dlg);
                    rethrow(ME);
                end
            end
        end

        % Value changed function: ControlSateliiDropDown
        function ControlSateliiDropDownValueChanged(app, event)
            % Obține indicele selectat din ItemsData
            selectedIndex = app.ControlSateliiDropDown.Value;
            if isempty(selectedIndex)
                uialert(app.UIFigure, 'Nu a fost selectat niciun satelit.', 'Eroare');
                return;
            end
        
            % Extrage indicii pentru constelație și satelit
            idxConst = selectedIndex{1};
            idxSat = selectedIndex{2};
        
            % Verifică validitatea indicilor
            if idxConst > length(app.Constelatii) || idxSat > length(app.Constelatii(idxConst).Sateliti)
                uialert(app.UIFigure, 'Index invalid pentru constelație sau satelit.', 'Eroare');
                return;
            end
        
            % Preia satelitul selectat
            selectedSatelit = app.Constelatii(idxConst).Sateliti(idxSat);
            
            if selectedSatelit.IsVisible && app.isViewerOpen()
                show(selectedSatelit.Object);
            end
            % Actualizează valorile din checkboxes
            app.AfieazsatelitCheckBox.Value = selectedSatelit.IsVisible;
            app.UrmalasolCheckBox.Value = selectedSatelit.GroundTrackVisible;
            app.FotografieazCheckBox.Value=selectedSatelit.FlagCamera;
            % Apelează funcția care actualizează parametrii satelitului folosind timpul de referință
            updateSatelliteParameters(app);
            updateStationParameters(app);
        end

        % Callback function
        function VizualizareButton_2Pushed(app, event)

        end

        % Drop down opening function: ControlConstelaieDropDown
        function ControlConstelaieDropDownOpening(app, event)

        end

        % Value changed function: AfieazsatelitCheckBox
        function AfieazsatelitCheckBoxValueChanged2(app, event)
            % Verifică dacă fereastra de vizualizare este activă
            if ~app.isViewerOpen()
                uialert(app.UIFigure, 'Fereastra de vizualizare nu este pornită. Porniți vizualizarea înainte de a face modificări.', 'Eroare');
                % Reset the checkbox to its previous value
                app.AfieazsatelitCheckBox.Value = false;
                return;
                
            end
        
            isChecked = app.AfieazsatelitCheckBox.Value;
            selectedIndex = app.ControlSateliiDropDown.Value;
        
            % Verifică validitatea indexului selectat
            if isempty(selectedIndex)
                uialert(app.UIFigure, 'Nu a fost selectat niciun satelit.', 'Eroare');
                % Reset the checkbox to its previous value
                app.AfieazsatelitCheckBox.Value = false;
                return;
            end
        
            % Găsește satelitul selectat în structura Constelatii
            idxConst = selectedIndex{1};
            idxSat = selectedIndex{2};
        
            % Verifică dacă indexul constelației și al satelitului sunt valide
            if idxConst > length(app.Constelatii) || idxSat > length(app.Constelatii(idxConst).Sateliti)
                uialert(app.UIFigure, 'Index invalid pentru constelație sau satelit.', 'Eroare');
                % Reset the checkbox to its previous value
                app.AfieazsatelitCheckBox.Value = false;
                return;
            end
        
            % Accesează satelitul selectat
            satelit = app.Constelatii(idxConst).Sateliti(idxSat);
            % Actualizează vizibilitatea satelitului selectat
            satelit.IsVisible = isChecked;
            if isChecked 
                show(satelit.Object);
                if app.UrmalasolCheckBox.Value
                    show(satelit.GroundTrack)
                end
            else
                hide(satelit.Object);
            end
            % Salvează modificarea în structura Constelatii
            app.Constelatii(idxConst).Sateliti(idxSat) = satelit;
        end

        % Value changed function: UrmalasolCheckBox
        function UrmalasolCheckBoxValueChanged2(app, event)
            if ~app.isViewerOpen()
                uialert(app.UIFigure, 'Fereastra de vizualizare nu este pornită. Porniți vizualizarea înainte de a face modificări.', 'Eroare');
                % Reset the checkbox to its previous value
                app.UrmalasolCheckBox.Value = false;
                return;
            end
            isChecked = app.UrmalasolCheckBox.Value; % Valoarea checkbox-ului
            selectedIndex = app.ControlSateliiDropDown.Value; % Satelitul selectat
            % Verifică validitatea indexului selectat
            if isempty(selectedIndex)
                uialert(app.UIFigure, 'Nu a fost selectat niciun satelit.', 'Eroare');
                % Reset the checkbox to its previous value
                app.UrmalasolCheckBox.Value = false;
                return;
            end
            % Găsește satelitul selectat în structura Constelatii
            idxConst = selectedIndex{1};
            idxSat = selectedIndex{2};
            % Verifică dacă indexul constelației și al satelitului sunt valide
            if idxConst > length(app.Constelatii) || idxSat > length(app.Constelatii(idxConst).Sateliti)
                uialert(app.UIFigure, 'Index invalid pentru constelație sau satelit.', 'Eroare');
                % Reset the checkbox to its previous value
                app.UrmalasolCheckBox.Value = false;
                return;
            end
            % Accesează satelitul selectat
            satelit = app.Constelatii(idxConst).Sateliti(idxSat);

            % Actualizează vizibilitatea urmei la sol a satelitului selectat
            satelit.GroundTrackVisible = isChecked;
            if isChecked
                % Dacă groundTrack nu a fost calculat încă, îl calculăm acum
                if isempty(satelit.GroundTrack)
                    durataScenariuSec = seconds(app.sc.StopTime - app.sc.StartTime);
                    try
                        satelit.GroundTrack = groundTrack(satelit.Object, 'TrailTime', durataScenariuSec);
                    catch ME
                        uialert(app.UIFigure, ['Eroare la calculul groundTrack: ' ME.message], 'Eroare');
                        return;
                    end
                else    
                    show(satelit.GroundTrack);
                end
            else
                hide(satelit.GroundTrack);
            end
            % Salvează modificarea în structura Constelatii
            app.Constelatii(idxConst).Sateliti(idxSat) = satelit;
        end

        % Button pushed function: tergeButton
        function tergeButtonPushed2(app, event)
            % Verifică dacă un satelit este selectat în dropdown
            selectedIndex = app.ControlSateliiDropDown.Value;
            if isempty(selectedIndex)
                uialert(app.UIFigure, 'Nu a fost selectat niciun satelit pentru ștergere.', 'Eroare');
                return;
            end
            % Găsește satelitul selectat în structura Constelatii
            idxConst = selectedIndex{1};
            idxSat = selectedIndex{2};
            % Verifică dacă indexurile sunt valide
            if idxConst > length(app.Constelatii) || idxSat > length(app.Constelatii(idxConst).Sateliti)
                uialert(app.UIFigure, 'Index invalid pentru constelație sau satelit.', 'Eroare');
                return;
            end
            % Obține informațiile despre constelație și satelit
            constelatie = app.Constelatii(idxConst);
            satelit = constelatie.Sateliti(idxSat);
            % Ascunde satelitul și ground track-ul acestuia
            hide(satelit.Object);
            %hide(satelit.GroundTrack);
            % Șterge satelitul din structura Constelatii
            app.Constelatii(idxConst).Sateliti(idxSat) = [];
            satToRemove = satelit.Object;
            if iscell(app.satelitiobj)
                % dacă e cell array
                mask = cellfun(@(s) isequal(s, satToRemove), app.satelitiobj);
                app.satelitiobj(mask) = [];
            else
                % dacă e vector simplu de obiecte Satellite
                mask = arrayfun(@(s) isequal(s, satToRemove), app.satelitiobj);
                app.satelitiobj(mask) = [];
            end
            % Actualizează informațiile constelației
            constelatie = app.Constelatii(idxConst);
            constelatie.NumarSateliti = length(constelatie.Sateliti);
            if constelatie.NumarSateliti > 0
                constelatie.AltitudineMedie = mean([constelatie.Sateliti.Altitudine]);
            else
                constelatie.AltitudineMedie = 0;
            end
            app.Constelatii(idxConst) = constelatie;
            % Actualizează dropdown-ul
            updateSatelliteDropdown(app);
            updateCountsInLabel(app);
            % Afișează un mesaj de confirmare
            uialert(app.UIFigure, sprintf('Satelitul "%s" a fost șters cu succes.', satelit.Nume), 'Succes');
        end

        % Value changed function: ControlConstelaieDropDown
        function ControlConstelaieDropDownValueChanged(app, event)
            % Obține indexul selectat din ItemsData
            idxConst = app.ControlConstelaieDropDown.Value;
            % Verifică dacă indexul este valid
            if isempty(idxConst) || idxConst > length(app.Constelatii)
                return;
            end
            % Obține numele constelației selectate
            constelatieSelectata = app.Constelatii(idxConst).Nume;
            % Afișează informațiile constelației
            afiseazaInformatiiConstelatie(app, constelatieSelectata);
            % Actualizează checkbox-ul pentru vizibilitate
            app.AfieazConstelaieCheckBox.Value = app.Constelatii(idxConst).IsVisible;
        end

        % Value changed function: AfieazConstelaieCheckBox
        function AfieazConstelaieCheckBoxValueChanged(app, event)
            % Check if the visualization window is active
            if ~app.isViewerOpen()
                uialert(app.UIFigure, 'Fereastra de vizualizare nu este pornită. Porniți vizualizarea înainte de a face modificări.', 'Eroare');
                % Reset the checkbox to its previous value
                app.AfieazConstelaieCheckBox.Value = ~app.AfieazConstelaieCheckBox.Value;
                return;
            end
        
            % Get the state of the "Afiseaza Constelatie" checkbox
            isChecked = app.AfieazConstelaieCheckBox.Value;
        
            % Get the selected constellation from the dropdown
            idxConst = app.ControlConstelaieDropDown.Value;
        
            % Validate the selected index
            if isempty(idxConst) || idxConst > length(app.Constelatii)
                uialert(app.UIFigure, 'Nu a fost selectată o constelație validă.', 'Eroare');
                % Reset the checkbox to its previous value
                app.AfieazConstelaieCheckBox.Value = ~app.AfieazConstelaieCheckBox.Value;
                return;
            end
        
            % Get the selected constellation
            constelatie = app.Constelatii(idxConst);
        
            % Update visibility for large and small constellations
            if constelatie.IsLarge
                if isChecked
                    show([app.Constelatii(idxConst).ObiectSateliti]);
                else
                    hide([app.Constelatii(idxConst).ObiectSateliti]);
                end

            else
                for idxSat = 1:length(constelatie.Sateliti)
                    satelit = constelatie.Sateliti(idxSat);
                    satelit.IsVisible = isChecked; % Update visibility state
                    if isChecked
                        show(satelit.Object);
                    else
                        hide(satelit.Object);
                    end
                    % Save changes back to the struct
                    app.Constelatii(idxConst).Sateliti(idxSat) = satelit;
                end
            end
            % Update constellation visibility
            app.Constelatii(idxConst).IsVisible = isChecked;
            % Update the constellation information in the text area
            afiseazaInformatiiConstelatie(app, constelatie.Nume);
        end

        % Callback function
        function OpreteButtonPushed(app, event)
             if ~isempty(app.sc.Viewers) && isvalid(app.sc.Viewers(1))
                close(app.sc.Viewers(1)); % Închide prima fereastră de simulare
                uialert(app.UIFigure, 'Fereastra de simulare a fost închisă.', 'Informație');
            else
                uialert(app.UIFigure, 'Nu există nicio fereastră de simulare activă.', 'Avertisment');
            end
        end

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
            % Solicită numele simulării
            answer = inputdlg('Introduceți un nume pentru simulare:', ...
                              'Nume simulare', [1 50], {'SimulareaMea'});
            if isempty(answer)
                % Utilizatorul a anulat dialogul
                uialert(app.UIFigure, 'Ați anulat inițializarea simulării.', 'Avertisment');
                return;
            end
            app.SimulationName = answer{1};
            
            % Crează dialogul de progres cu Indeterminate = 'off' pentru progres precis
            dlg = uiprogressdlg(app.UIFigure, ...
                                 'Title', 'Initializare Simulare', ...
                                 'Message', 'Pregătire inițializare simulare...', ...
                                 'Cancelable', 'on', ...
                                 'Indeterminate', 'off');
            dlg.Value = 0;
            
            % Actualizează eticheta de stare
            app.StatusLabel.Text = 'Scenariul de simulare se deschide, vă rugăm așteptați...';
            pause(0.1);  % Permite actualizarea UI-ului
            dlg.Value = 0.1;
            
            % Etapa 1: Încărcarea MySQL connector
            try
                javaaddpath('C:\Users\ungureanu.stefan\Desktop\Start LICENTA\mysql-connector-j-8.0.33\mysql-connector-j-8.0.33.jar');
                app.StatusLabel.Text = 'MySQL connector loaded successfully...';
                dlg.Value = 0.2;
                pause(0.1);
            catch ME
                close(dlg);
                uialert(app.UIFigure, ['Error loading MySQL connector: ' ME.message], 'Database Error');
                return;
            end
            
            % Etapa 2: Inițializarea scenariului
            if ~isScenarioInitialized(app)
                initializare_scenariu(app);
            end
            dlg.Value = 0.4;
            pause(0.1);
            
            % Etapa 3: Inițializarea conexiunii la baza de date
            initializeDatabaseConnection(app);
            dlg.Value = 0.5;
            pause(0.1);
            
            % Etapa 4: Dezactivează butonul pentru a evita acțiuni multiple
            app.StartButton.Enable = 'off';
            dlg.Value = 0.55;
            pause(0.1);
            
            % Etapa 5: Deschide fereastra de vizualizare (viewer)
            if ~isViewerOpen(app)
                openViewer(app, answer{1});
                dlg.Value = 0.7;
                pause(0.1);
            else
                updateStatus(app, 'Fereastra de vizualizare este deja deschisă.');
                dlg.Value = 0.7;
                pause(0.1);
            end
            
            % Etapa 6: Pune simularea pe pauză (oprirea actualizărilor automate)
            app.sc.AutoSimulate = false;
            dlg.Value = 0.75;
            pause(0.1);
            
            % Etapa 7: Actualizarea interfeței și a elementelor UI
            updateConstellationUI(app);
            dlg.Value = 0.85;
            pause(0.1);
            
            updateCountsInLabel(app);
            dlg.Value = 0.95;
            pause(0.1);
            
            % Etapa finală: Reactivează butonul de start
            app.StartButton.Enable = 'on';
            dlg.Value = 1;
            pause(1); % Mică întârziere pentru a permite utilizatorului să observe finalizarea
            
            close(dlg);
        end

        % Button pushed function: nchideButton
        function nchideButtonPushed(app, event)
             selection = uiconfirm(app.UIFigure, ...
            'Sigur doriți să închideți aplicația?', ...
            'Închidere Aplicație', ...
            'Options', {'Da', 'Nu'}, ...
            'DefaultOption', 'Nu', ...
            'CancelOption', 'Nu');
        
        if strcmp(selection, 'Da')
            % Obține toate ferestrele (de tip figure) deschise în MATLAB
            allFigures = findall(0, 'Type', 'figure');
            % Parcurge lista și închide fiecare fereastră care nu este fereastra principală a aplicației
            for i = 1:length(allFigures)
                if allFigures(i) ~= app.UIFigure
                    close(allFigures(i));
                end
            end
            % Închide fereastra principală a aplicației
            delete(app);
        end
        end

        % Button pushed function: AdaugstaieButton
        function AdaugstaieButtonPushed(app, event)
                persistent manualfig;
                if ~isempty(manualfig) && isvalid(manualfig)
                    figure(manualfig); 
                    return;
                end
                screenSize = get(groot, 'ScreenSize');
                windowWidth = 600; 
                windowHeight = 500;
                windowX = (screenSize(3) - windowWidth) / 2;
                windowY = (screenSize(4) - windowHeight) / 2;
            
                manualfig = uifigure('Name', 'Adaugă Stație', ...
                               'Position', [windowX, windowY, windowWidth, windowHeight], ...
                               'Color', [0.95 0.95 0.95],...
                               'CloseRequestFcn',  @closeManualWindow);
            
                uilabel(manualfig, 'Text', 'Adaugă Stație Manual', ...
                        'FontSize', 16, 'FontWeight', 'bold', ...
                        'HorizontalAlignment', 'center', ...
                        'Position', [180, 450, 250, 30], ...
                        'FontColor', [0.2, 0.2, 0.7]);
            
                uilabel(manualfig, 'Text', 'Nume Stație:', 'Position', [50, 400, 100, 22]);
                editNume = uieditfield(manualfig, 'text', 'Position', [180, 400, 300, 22]);
            
                uilabel(manualfig, 'Text', 'Latitudine:', 'Position', [50, 350, 100, 22]);
                latSelector = uidropdown(manualfig, 'Items', {'N', 'S'}, 'Position', [180, 350, 50, 22]);
                latGrade = uieditfield(manualfig, 'numeric', 'Limits', [0, 90], 'Position', [240, 350, 50, 22]);
                latMinute = uieditfield(manualfig, 'numeric', 'Limits', [0, 59], 'Position', [300, 350, 50, 22]);
                latSecunde = uieditfield(manualfig, 'numeric', 'Limits', [0, 59], 'Position', [360, 350, 50, 22]);
            
                uilabel(manualfig, 'Text', 'Longitudine:', 'Position', [50, 300, 100, 22]);
                lonSelector = uidropdown(manualfig, 'Items', {'E', 'W'}, 'Position', [180, 300, 50, 22]);
                lonGrade = uieditfield(manualfig, 'numeric', 'Limits', [0, 180], 'Position', [240, 300, 50, 22]);
                lonMinute = uieditfield(manualfig, 'numeric', 'Limits', [0, 59], 'Position', [300, 300, 50, 22]);
                lonSecunde = uieditfield(manualfig, 'numeric', 'Limits', [0, 59], 'Position', [360, 300, 50, 22]);
            
                uibutton(manualfig, 'Text', 'Alege coordonate', ...
                         'Position', [180, 250, 200, 30], ...
                         'FontSize', 12, 'BackgroundColor', [0.2, 0.6, 0.8], ...
                         'ButtonPushedFcn', @(btn, event) selectCoordinates(app, editNume, latSelector, latGrade, latMinute, latSecunde, lonSelector, lonGrade, lonMinute, lonSecunde));
            
                resultArea = uitextarea(manualfig, 'Editable', 'off', ...
                                        'Position', [50, 180, 500, 50]);
            
                uibutton(manualfig, 'push', 'Text', 'Adaugă Stația', ...
                         'Position', [220, 120, 150, 30], ...
                         'ButtonPushedFcn', @(btn, event) adaugaStatia());
                function closeManualWindow(src, ~)
                    delete(src); 
                    manualfig = [];  
                end
                function adaugaStatia()
                    if isempty(editNume.Value)
                        uialert(fig, 'Introduceți un nume pentru stație.', 'Eroare');
                        return;
                    end
            
                    latCard = latSelector.Value;
                    latVal = conversie_coordonata(latCard, latGrade.Value, latMinute.Value, latSecunde.Value);
            
                    lonCard = lonSelector.Value;
                    lonVal = conversie_coordonata(lonCard, lonGrade.Value, lonMinute.Value, lonSecunde.Value);
            
                    % Verifică dacă scenariul a fost inițializat
                    if ~app.isScenarioInitialized() || ~isvalid(app.sc)
                        uialert(app.UIFigure, 'Scenariul nu este inițializat. Apăsați butonul "Start" pentru a inițializa simularea.', 'Eroare');
                        return;
                    end

                    try
                        newStation = struct( ...
                                'Name', editNume.Value, ...
                                'Object', groundStation(app.sc, latVal, lonVal, 'Name', editNume.Value), ...
                                'IsVisible', isSimulationRunning(app), ...
                                'Latitude', latVal, ...
                                'Longitude', lonVal, ...
                                'AntennaSelection', 'Gaussian Antenna', ...
                                'Links', struct( ...
                                    'Uplink', struct( ...
                                        'FrequencyGHz', [], ...
                                        'BandwidthMHz', [], ...
                                        'BitRateMbps', [], ...
                                        'RequiredEbByNo_dB', [], ...
                                        'PolarizationMismatch_deg', [], ...
                                        'ImplementationLoss', [], ...
                                        'AntennaMispointingLoss', [], ...
                                        'RadomeLoss', [] ...
                                    ), ...
                                    'Downlink', struct( ...
                                        'FrequencyGHz', [], ...
                                        'BandwidthMHz', [], ...
                                        'BitRateMbps', [], ...
                                        'RequiredEbByNo_dB', [], ...
                                        'PolarizationMismatch_deg', [], ...
                                        'ImplementationLoss', [], ...
                                        'AntennaMispointingLoss', [], ...
                                        'RadomeLoss', [] ...
                                    ) ...
                                ), ...
                                'VisibilityConstraints', struct( ...
                                    'MinElevation', 10, ...
                                    'MaxRange', [] ...
                                ), ...
                                'AccessLog', struct( ...
                                    'Satellite', {{}}, ...
                                    'AccessIntervals', {{}}, ...
                                    'AccessObject', {{}} ...
                                ), ...
                                'Emisie', struct( ...
                                    'Altitude', [], ...
                                    'TxFeederLoss', [], ...
                                    'OtherTxLosses', [], ...
                                    'TxHPAPower', [], ...
                                    'TxHPAOBO', [], ...
                                    'TxAntennaGain', [] ...
                                ), ...
                                'Receptie', struct( ...
                                    'Altitude', [], ...
                                    'InterferenceLoss', [], ...
                                    'RxGByT', [], ...
                                    'RxFeederLoss', [], ...
                                    'OtherRxLosses', [] ...
                                ), ...
                                'Meteo', struct( ...
                                    'Temperature_C', [], ...
                                    'Humidity_proc', [], ...
                                    'Pressure_hPa', [] ...
                                ), ...
                                'Receiver', [], ...
                                'Emitter', [] ...
                            );
                        app.GroundStations(end+1) = newStation;
                        updateGroundStationDropdown(app);
                        updateCountsInLabel(app)
                        updateSourceDestinationDropdowns(app);
                        resultArea.Value = sprintf(['Stația: %s\nLatitudine: %.5f°\nLongitudine: %.5f°\n' ...
                                                   'Stația a fost adăugată cu succes în simulare!'], ...
                                                   editNume.Value, latVal, lonVal);
                        resetFields();
                    catch ME
                        uialert(app.UIFigure, sprintf('Eroare la adăugarea stației: %s', ME.message), 'Eroare');
                    end
                end
            
                function l = conversie_coordonata(cardinal, grade, minute, secunde)
                    p = 1;
                    if strcmp(cardinal, 'S') || strcmp(cardinal, 'W')
                        p = -1;
                    end
                    l = p * (grade + minute/60 + secunde/3600);
                end
            
                function resetFields()
                    editNume.Value = '';
                    latSelector.Value = 'N'; latGrade.Value = 0; latMinute.Value = 0; latSecunde.Value = 0;
                    lonSelector.Value = 'E'; lonGrade.Value = 0; lonMinute.Value = 0; lonSecunde.Value = 0;
                end
            
                function selectCoordinates(~, editNume, latSelector, latGrade, latMinute, latSecunde, lonSelector, lonGrade, lonMinute, lonSecunde)
                    stationName = strtrim(editNume.Value);
                
                    if isempty(stationName)
                        errordlg('Introduceți un nume pentru stație înainte de a selecta coordonatele!', 'Eroare');
                        return;
                    end
                
                    userHome = getenv('USERPROFILE');  
                    downloadsFolder = fullfile(userHome, 'Downloads');
                    coordFile = fullfile(downloadsFolder, sprintf('%s.txt', stationName));
                    if exist(coordFile, 'file')
                         loadCoordinatesFromFile(coordFile, latSelector, latGrade, latMinute, latSecunde, lonSelector, lonGrade, lonMinute, lonSecunde);
                        return;
                    else
                        web(fullfile(pwd, 'map.html'), '-browser');
                        uiwait(msgbox('Alegeți o locație pe hartă și închideți această fereastră când ați terminat.', 'Instrucțiuni'));
                        if ~exist(coordFile, 'file')
                            errordlg(sprintf('Fișierul %s nu a fost găsit în folderul Descărcări.', coordFile), 'Eroare');
                            return;
                        end   
                                    
                        loadCoordinatesFromFile(coordFile, latSelector, latGrade, latMinute, latSecunde, lonSelector, lonGrade, lonMinute, lonSecunde);
                    end
                    
                end
                function loadCoordinatesFromFile(coordFile, latSelector, latGrade, latMinute, latSecunde, lonSelector, lonGrade, lonMinute, lonSecunde)
                    try
                        fileID = fopen(coordFile, 'r');
                        data = fgetl(fileID);
                        fclose(fileID);
            
                        coords = sscanf(data, '%f,%f');
                        lat = coords(1);
                        lon = coords(2);
            
                        [latDeg, latMin, latSec] = deg2dms_custom(abs(lat));
                        [lonDeg, lonMin, lonSec] = deg2dms_custom(abs(lon));
            
                        latSelector.Value = 'N'; if lat < 0, latSelector.Value = 'S'; end
                        lonSelector.Value = 'E'; if lon < 0, lonSelector.Value = 'W'; end
            
                        latGrade.Value = latDeg; latMinute.Value = latMin; latSecunde.Value = latSec;
                        lonGrade.Value = lonDeg; lonMinute.Value = lonMin; lonSecunde.Value = lonSec;
                    catch
                        errordlg('Eroare la citirea coordonatelor.', 'Eroare');
                    end
                end
                function [deg, min, sec] = deg2dms_custom(decimalDegrees)
                    deg = floor(decimalDegrees);
                    min = floor((decimalDegrees - deg) * 60);
                    sec = (decimalDegrees - deg - min/60) * 3600;
                    sec = round(sec, 2);
                end
                
        end

        % Callback function
        function VizualizareButtonPushed(app, event)
           
        end

        % Button pushed function: tergeButton_2
        function tergeButton_2Pushed(app, event)
            idx = app.ControlStaieDropDown.Value;
            if isempty(idx) || idx > length(app.GroundStations)
                uialert(app.UIFigure, 'Nu a fost selectată o stație de sol pentru ștergere.', 'Eroare');
                return;
            end
            
            stationName = app.GroundStations(idx).Name;
            % Ascunde stația înainte de ștergere
            hide(app.GroundStations(idx).Object);
            app.AfieazCheckBox_2.Value = false;
            % Șterge stația din structura de stocare
            app.GroundStations(idx) = [];
            updateGroundStationDropdown(app);
            updateCountsInLabel(app);
            updateSourceDestinationDropdowns(app);
            uialert(app.UIFigure, sprintf('Stația "%s" a fost ștearsă cu succes.', stationName), 'Succes');
        end

        % Value changed function: AfieazCheckBox_2
        function AfieazCheckBox_2ValueChanged(app, event)
            if ~app.isViewerOpen()
                uialert(app.UIFigure, 'Fereastra de vizualizare nu este pornită. Porniți vizualizarea înainte de a face modificări.', 'Eroare');
                % Resetăm checkbox-ul la valoarea anterioară
                app.AfieazCheckBox_2.Value = ~app.AfieazConstelaieCheckBox.Value;
                return;
            end
            idx = app.ControlStaieDropDown.Value;  % presupunem că Value stochează indexul
            if isempty(idx) || idx > length(app.GroundStations)
                uialert(app.UIFigure, 'Nu a fost selectată o stație de sol validă.', 'Eroare');
                return;
            end
        
            isChecked = app.AfieazCheckBox_2.Value;  % valoarea checkbox‑ului
            % Actualizează starea în variabila stațiilor de sol
            app.GroundStations(idx).IsVisible = isChecked;
            
            % Afișează sau ascunde stația de sol în funcție de starea checkbox‑ului
            if isChecked
                show(app.GroundStations(idx).Object);
            else
                hide(app.GroundStations(idx).Object);
            end
        end

        % Drop down opening function: ControlStaieDropDown
        function ControlStaieDropDownOpening(app, event)

        end

        % Value changed function: ControlStaieDropDown
        function ControlStaieDropDownValueChanged(app, event)
            idx = app.ControlStaieDropDown.Value;  % Value conține indexul stației selectate
            if isempty(idx) || idx > length(app.GroundStations)
                return;
            end
            
            % Preia starea curentă a stației de sol
            isVisible = app.GroundStations(idx).IsVisible;
            
            % Actualizează checkbox-ul pentru a reflecta starea stației
            app.AfieazCheckBox_2.Value = isVisible;
            updateStationParameters(app);
            % Verifică starea stației și afișează/ascunde obiectul corespunzător
            if isVisible
                show(app.GroundStations(idx).Object);
            else
                hide(app.GroundStations(idx).Object);
            end
        end

        % Button pushed function: AcoperireButton
        function AcoperireButtonPushed(app, event)
             %% 1) Verificări inițiale pentru scenariu și viewer
            if isempty(app.sc) || ~isvalid(app.sc)
                uialert(app.UIFigure, 'Simularea nu este inițializată.', 'Eroare');
                return;
            end
            % Pornește simularea automat dacă e oprită
            if ~app.sc.AutoSimulate
                app.sc.AutoSimulate = true;
                pause(0.5);
            end
            % Deschide viewer-ul dacă nu e deja
            if ~app.isViewerOpen()
                app.v = satelliteScenarioViewer(app.sc, "ShowDetails", false);
                pause(0.5);
            end
            % Preia timpul curent al scenariului
            t0 = app.v.CurrentTime;
            %% 2) Selectare constelație, sateliți și stație de sol
            % a) constelație + sateliți
            idxConst = app.ControlConstelaieDropDown.Value;
            selConst  = app.Constelatii(idxConst);
            if selConst.IsLarge
                sats = selConst.ObiectSateliti;
            else
                sats = [selConst.Sateliti.Object];
            end
            fprintf('* %d sateliți selectați\n', numel(sats));
    
            % b) ground station
            idxGS   = app.ControlStaieDropDown.Value;
            gsMain  = app.GroundStations(idxGS);
            statLat = gsMain.Latitude;
            statLon = gsMain.Longitude;
            gsName  = gsMain.Name;
            fprintf('* GS principal: "%s" @ [%.4f, %.4f]\n', gsName, statLat, statLon);
            halfBW  = 62.7;      % deg
            % c) transmitătoare (create or reuse)
            if isempty(selConst.Emitter)
                fq      = 16e9;    % Hz
                txPower = 20;        % dBW
                txs     = transmitter(sats, 'Frequency', fq, 'Power', txPower);
                gaussianAntenna(txs, 'DishDiameter', ...
                    (70*(physconst('Lightspeed')/fq))/(2*halfBW));
                app.Constelatii(idxConst).Emitter = txs;
            end

            %% 3) Generare grilă și buffer în jurul stației
            % a) grid + buffer
            [gridpts,inregion,latlim,lonlim,gridlat,gridlon,latb,lonb] = ...
                 generateGridAndRegion(statLat, statLon, 150, 0.1, 2);
            gslat = gridlat(inregion);
            gslon = gridlon(inregion);
            gs = groundStation(app.sc,gslat,gslon);
            isotropic = arrayConfig(Size=[1 1]);
            rxs = receiver(gs,Antenna=isotropic);
            % b) apel calcul acoperire
            coveragedata = satcoverage(gridpts, sats, rxs, t0, halfBW, inregion);
            fprintf('DEBUG: size(coveragedata) = %s\n', mat2str(size(coveragedata)));
            disp('DEBUG: coveragedata = ');
            disp(coveragedata);
            clear("rxs");
            %% 4) Afișare rezultate
            % Extragem toate valorile finite într-un vector
            vals = coveragedata(~isnan(coveragedata));
            if isempty(vals)
                % Nu există acoperire → informăm utilizatorul și ieșim
                uialert(app.UIFigure, ...
                    'Nu există acoperire pentru configurația curentă.', ...
                    'Informație');
                hide(gs);
                clear("gs");
                return;
            end
            
            % În acest punct avem cel puțin un scalar în vals
            minpowerlevel = floor( min(vals) / 10 ) * 10;
            maxpowerlevel = ceil(  max(vals) / 10 ) * 10;
            
            % Debug: ne asigurăm că sunt scalari
            assert( isscalar(minpowerlevel) && isscalar(maxpowerlevel), ...
                    'Nivelurile de putere nu sunt scalari!' );
            fprintf('minpowerlevel = %d dBm, maxpowerlevel = %d dBm\n', ...
                     minpowerlevel, maxpowerlevel);

            
            figure
            worldmap(latlim, lonlim)
            mlabel south
            
            % 4.1) Contur raster
            colormap turbo
            clim([minpowerlevel, maxpowerlevel])
            geoshow(gridlat, gridlon, coveragedata, ...
                    'DisplayType','contour','Fill','on');
            
            % 4.2) Buffer-ul
            plotm(latb, lonb, 'k-', 'LineWidth', 1.5);
            
            % 4.3) Stația principală
            plotm(statLat, statLon, 'rp', 'MarkerSize',12, 'MarkerFaceColor','r');
            textm(statLat, statLon, gsName, ...
                  'HorizontalAlignment','center', 'FontWeight','bold');
            
            % 4.4) Opțional: puncte grid colorate după semnal
            scatterm( gridlat(inregion), gridlon(inregion), 20, ...
                      coveragedata(inregion), 'filled' );
            
            % 4.5) Colorbar și titlu
            cBar = contourcbar;
            title(cBar, 'Power (dBm)');
            title(sprintf('Acoperire %s asupra %s la %s UTC', ...
                  selConst.Nume, gsName, datestr(t0,'HH:MM:SS')));
            hide(gs);
            clear("gs");
            function [gridpts, inregion, latlim, lonlim, gridlat, gridlon, latb, lonb] = ...
                generateGridAndRegion(statLat,statLon,maxPoints,spacingDeg,bufdeg)
                % GENERATEGRIDANDREGION  generează o grilă de puncte în UTM în jurul statiei
                %   [gridpts,inregion] = generateGridAndRegion(app, lat, lon, N, ddeg, bdeg)
                %
                %   - statLat, statLon : coordonate staţie
                %   - maxPoints         : număr maxim de puncte (ex. 150)
                %   - spacingDeg        : rezoluţie grilă în grade (ex. 1)
                %   - bufdeg            : raza buffer în grade (ex. 1)
        
                % 1) calculăm dimensiunile grilei
                nLat = floor(sqrt(maxPoints));
                nLon = floor(maxPoints/nLat);
                latSpan = (nLat-1)*spacingDeg;
                lonSpan = (nLon-1)*spacingDeg;
                latlim = [statLat - latSpan/2, statLat + latSpan/2];
                lonlim = [statLon - lonSpan/2, statLon + lonSpan/2];
        
                % 2) determinăm EPSG-ul UTM pentru staţie
                zoneStr = utmzone(statLat, statLon);
                zoneNum = str2double(zoneStr(1:2));
                if zoneStr(end)=='S'
                    epsgCode = 32700 + zoneNum;
                else
                    epsgCode = 32600 + zoneNum;
                end
                projUTM = projcrs(epsgCode);
        
                % 3) proiectăm şi construim grila în metri
                spacingXY = deg2km(spacingDeg)*1000;
                [xlim, ylim] = projfwd(projUTM, latlim, lonlim);
                R = maprefpostings(xlim, ylim, spacingXY, spacingXY);
                [X, Y] = worldGrid(R);
                [gridlat, gridlon] = projinv(projUTM, X, Y);
        
                % 4) buffer în grade şi poligonul regiunii
                [latb, lonb] = bufferm(statLat, statLon, bufdeg, 'outPlusInterior');
                regionShape    = geopolyshape(latb, lonb);
        
                % 5) filtrăm punctele
                gridpts = geopointshape(gridlat, gridlon);
                inregion = isinterior(regionShape, gridpts);
            end
             function coveragedata = satcoverage(gridpts, sats, rxs, timeIn, halfBeamWidth, inregion)
                % SATCOVERAGE  Puţerea (dBm) recepţionată la fiecare punct din grid.
                %
                % IN:
                %   gridpts       - geopointshape vector (toate punctele grilei)
                %   sats          - array de Satellite (din constelaţie)
                %   txs           - array de Transmitter (fiecare sat k are txs(k))
                %   rxs           - array de Receiver (punctele din grid)
                %   timeIn        - datetime la care facem calculul
                %   halfBeamWidth - unghi jumătate‐fascicul [°]
                %   inregion      - logical mask (numel(gridpts)×1) a buffer‐ului
                %
                % OUT:
                %   coveragedata  - vector (numel(gridpts)×1) cu dBm
        
                coveragedata = NaN(size(gridpts));
        
                fprintf("=== SATCOVERAGE DEBUG ===\n");
                fprintf("Număr sateliți: %d\n", numel(sats));
                fprintf("Număr receivere grid: %d\n\n", numel(rxs));
        
                % Calculăm pozițiile tuturor sateliților
                llaAll = states(sats, timeIn, "CoordinateFrame","geographic");
        
                for k = 1:numel(sats)
                    fprintf("--- Satelit %d/%d ---\n", k, numel(sats));
                    latk = llaAll(1,1,k);
                    lonk = llaAll(2,1,k);
                    altk = llaAll(3,1,k);
                    fprintf("Pos: %.4f°, %.4f°, %.0f m\n", latk, lonk, altk);
        
                    % 1) Generăm FOV‐ul pe Pământ
                    fov = fieldOfViewShape(llaAll(:,1,k), halfBeamWidth);
        
                    % 2) Filtrăm punctele grilei care sunt în FOV + în buffer
                    inFOV = isinterior(fov, gridpts);
                    idxs = inFOV(inregion);
                    fprintf('Number of grid points in FOV: %d\n', sum(inFOV));
                    fprintf('Number of receivers in FOV: %d\n', sum(idxs));
        
                    % 3) Creăm link‐uri şi calculăm sigstrength
                    try
                        gridsigstrength = NaN(size(gridpts));
                         if any(idxs)
                            tx = sats(k).Transmitters;
                            lnks = link(tx,rxs(idxs));
                            rxsigstrength = sigstrength(lnks,timeIn)+30; % Convert from dBW to dBm
                
                            fprintf('Signal strength (dBm): ');
                            fprintf('%.2f ', rxsigstrength);
                            fprintf('\n');
                
                            gridsigstrength(inregion & inFOV) = rxsigstrength;
                            delete(lnks)
                        else
                            fprintf('No receivers in FOV for satellite #%d\n', k);
                        end
                    catch ME
                        fprintf("Eroare la link/sigstrength: %s\n", ME.message);
                        continue;
                    end
        
                    % 4) Actualizăm cu maximul
                    coveragedata = max(gridsigstrength,coveragedata);
                end
        
                fprintf("=== Gata SATCOVERAGE ===\n\n");
            end
        
            
            function satFOV = fieldOfViewShape(lla,halfViewAngle)
            
                % Find the Earth central angle using the beam view angle
                if isreal(acosd(sind(halfViewAngle)*(lla(3)+earthRadius)/earthRadius))
                    % Case when Earth FOV is bigger than antenna FOV 
                    earthCentralAngle = 90-acosd(sind(halfViewAngle)*(lla(3)+earthRadius)/earthRadius)-halfViewAngle;
                else
                    % Case when antenna FOV is bigger than Earth FOV 
                    earthCentralAngle = 90-halfViewAngle;
                end
            
                % Create a buffer zone centered at the position of the satellite with a buffer of width equaling the Earth central angle
                [latBuff,lonBuff] = bufferm(lla(1),lla(2),earthCentralAngle,"outPlusInterior",100);
            
                % Handle the buffer zone crossing over -180/180 degrees
                if sum(abs(lonBuff) == 180) > 2
                    crossVal = find(abs(lonBuff)==180) + 1;
                    lonBuff(crossVal(2):end) = lonBuff(crossVal(2):end) - 360 *sign(lonBuff(crossVal(2)));
                elseif sum(abs(lonBuff) == 180) == 2
                    lonBuff = [lonBuff; lonBuff(end); lonBuff(1); lonBuff(1)];
                    if latBuff(1) > 0
                        latBuff = [latBuff; 90; 90; latBuff(1)];
                    else
                        latBuff = [latBuff; -90; -90; latBuff(1)];
                    end
                end
            
                % Create geopolyshape from the resulting latitude and longitude buffer zone values
                satFOV = geopolyshape(latBuff,lonBuff);
            end
        end

        % Button pushed function: LinkBudgetButton
        function LinkBudgetButtonPushed(app, event)
            % Verificări scenariu
            if isempty(app.sc) || ~isvalid(app.sc)
                uialert(app.UIFigure, 'Scenariul nu este inițializat.', 'Eroare'); return;
            end
            if ~app.sc.AutoSimulate
                app.sc.AutoSimulate = true;
                pause(0.5);
            end
        
            % Selectare stații sursă și țintă
            idxSource = app.StaiesursDropDown.Value;
            idxTarget = app.StaiedestinaieDropDown.Value;
            if isempty(idxSource) || isempty(idxTarget) || idxSource==idxTarget
                uialert(app.UIFigure, 'Selectați două stații de sol diferite.', 'Eroare'); return;
            end
            gsSourceStruct = app.GroundStations(idxSource);
            gsTargetStruct = app.GroundStations(idxTarget);
        
            % Vector de sateliți
            satVector = app.satelitiobj;
            if iscell(satVector), satVector = [satVector{:}]; end
            if isempty(satVector)
                uialert(app.UIFigure, 'Vectorul de sateliți este gol.', 'Eroare'); return;
            end
        
            % Alegere path de relay (doi sateliți)
            satObj1 = selectBestRelaySatellite(gsSourceStruct.Object, gsTargetStruct.Object, satVector, app.UserSelectedTime);

            if isequal(satObj1,0)
                uialert(app.UIFigure, 'Nu există o cale între cele două stații.', 'Eroare');
                return;
            end
            % Găsim indexul în Constelatii (dacă există)
            info1 = findSatelliteInConstellations(app, satObj1);
            
            % Pregătim structurile pentru UI:
            if ~isempty(info1.constIdx)
                % Satelit din constelație „mică” – preluăm structura completă
                satStruct1 = app.Constelatii(info1.constIdx).Sateliti(info1.satIdx);
            else
                % Satelit din constelație „islarge” – completare minimală
                satStruct1 = struct( ...
                    'Nume',   satObj1.Name, ...
                    'Object', satObj1, ...
                    'Emisie', struct( ...
                        'TxFeederLoss',  [], ...
                        'OtherTxLosses', [], ...
                        'TxHPAPower',    [], ...
                        'TxHPAOBO',      [], ...
                        'TxAntennaGain', []  ...
                    ), ...
                    'Receptie', struct( ...
                        'InterferenceLoss', [], ...
                        'RxGByT',           [], ...
                        'RxFeederLoss',     [], ...
                        'OtherRxLosses',    []  ...
                    ) ...
                );
            end
            
            % Afișare UI pentru editare parametri link
            [gsSourceOut, sat1Out, gsTargetOut, success] = ...
                linkBudgetUI(gsSourceStruct, satStruct1, gsTargetStruct);

            % Salvare rezultate dacă a avut loc aplicare
            if success
                app.GroundStations(idxSource) = gsSourceOut;
                app.GroundStations(idxTarget) = gsTargetOut;
                if ~isempty(info1.constIdx)
                    app.Constelatii(info1.constIdx).Sateliti(info1.satIdx) = sat1Out;
                end
                uialert(app.UIFigure, 'Parametrii modificați cu succes.', 'Succes');
            else
                uialert(app.UIFigure, 'Parametrii au rămas cei standard.', 'Info');
                return;
            end

            %% Calculeaza parametrii pentru obiectele de emisie si receptie
            [~, el_up,   r_up]   = aer( gsSourceOut.Object, sat1Out.Object, app.UserSelectedTime );
            [~, el_down, r_down] = aer( gsTargetOut.Object, sat1Out.Object , app.UserSelectedTime );

            fprintf('--- UPLINK INPUTS ---\n');
            assert(isstruct(gsSourceOut.Emisie), 'gsSourceOut.Emisie must be a struct');
            disp(gsSourceOut.Emisie);
            assert(isstruct(gsSourceOut.Links.Uplink), 'gsSourceOut.Links.Uplink must be a struct');
            disp(gsSourceOut.Links.Uplink);
            fprintf('el_up = %.3f deg, r_up = %.3f m\n', el_up, r_up);
            
            fprintf('--- DOWNLINK INPUTS ---\n');
            assert(isstruct(sat1Out.Emisie), 'sat1Out.Emisie must be a struct');
            disp(sat1Out.Emisie);
            assert(isstruct(gsTargetOut.Receptie), 'gsTargetOut.Receptie must be a struct');
            disp(gsTargetOut.Receptie);
            assert(isstruct(gsTargetOut.Links.Downlink), 'gsSourceOut.Links.Downlink must be a struct');
            disp(gsTargetOut.Links.Downlink);
            fprintf('el_down = %.3f deg, r_down = %.3f m\n', el_down, r_down);

            res1 = calculateLinkBudget( ...
                gsSourceOut.Emisie, sat1Out.Receptie, gsSourceOut.Links.Uplink, ...
                el_up,   r_up );
            res2 = calculateLinkBudget( ...
                sat1Out.Emisie, gsTargetOut.Receptie, gsTargetOut.Links.Downlink, ...
                el_down, r_down );

            % puterea recepționată (dBm) la intrarea LNA
            Rpwr1_dBm = res1.ReceivedIsotropicPower ...
                      + sat1Out.Receptie.RxGByT ...
                      - sat1Out.Receptie.RxFeederLoss ...
                      - sat1Out.Receptie.OtherRxLosses ...
                      + 30;
            Rpwr2_dBm = res2.ReceivedIsotropicPower ...
                      + gsTargetOut.Receptie.RxGByT ...
                      - gsTargetOut.Receptie.RxFeederLoss ...
                      - gsTargetOut.Receptie.OtherRxLosses ...
                      + 30;
            display(Rpwr1_dBm);display(Rpwr2_dBm);

            %% Adauga gimbal pentru obiectele scenariului
            %––– 1) Gimbal emițător pe stația sursă –––––––––––––––––––––––––––––––––%
            gsSourceOutTxGimbal = gimbal(gsSourceOut.Object, ...
                'Name', 'Gimbal_GS_Source_Tx',...
                'MountingLocation', [0;0;-gsSourceOut.Emisie.Altitude],...
                'MountingAngles',[0;180;0] ); 

            %––– 2) Gimbal receptor pe stația țintă ––––––––––––––––––––––––––––––––%
            gsTargetOutRxGimbal = gimbal(gsTargetOut.Object, ...
                'Name', 'Gimbal_GS_Target_Rx',...
                'MountingLocation', [0;0;-gsTargetOut.Receptie.Altitude],...
                'MountingAngles',[0;180;0] ); 

            %––– 3) Gimbale Sat1 –––––––––––––––––––––––––––––––––––––––––––––––––––%
            sat1OutTxGimbal = gimbal(sat1Out.Object, ...
                'Name', 'Gimbal_SAT_Tx',...
                'MountingLocation', [0;1;2]); ...  % 1 m pe laterală, 2 m sus
            sat1OutRxGimbal = gimbal(sat1Out.Object, ...
                'Name', 'Gimbal_SAT_Rx',...
                'MountingLocation', [0;-1;2]); ... % 1 m pe laterală opusă, 2 m sus

            %% Adauga obiecte de emisie si receptie
            %––– 1) Gaussian Transmitter pe stația sursă –––––––––––––––––––––––––––––
            sysLossTxGS = gsSourceOut.Emisie.TxFeederLoss + ...
              gsSourceOut.Emisie.OtherTxLosses + ...
              gsSourceOut.Links.Uplink.RadomeLoss;
            Dsol=2; 
            eta = computeApertureEfficiency(Dsol,gsSourceOut.Emisie.TxAntennaGain, gsSourceOut.Links.Uplink.FrequencyGHz);
            display(eta);

            gsSourceOutTransmitter = transmitter( ...
                gsSourceOutTxGimbal, ...
                'Name',       'GS_Source_Tx', ...
                'MountingLocation',[0;0;Dsol], ...
                'Frequency',  gsSourceOut.Links.Uplink.FrequencyGHz * 1e9, ...
                'Power',      gsSourceOut.Emisie.TxHPAPower - gsSourceOut.Emisie.TxHPAOBO, ...
                'SystemLoss', sysLossTxGS, ...
                'BitRate',    gsSourceOut.Links.Uplink.BitRateMbps);
            gaussianAntenna(gsSourceOutTransmitter, ...
                "DishDiameter",Dsol,....
                "ApertureEfficiency", eta); % meters

            %––– 2) Gaussian Receiver pe stația țintă –––––––––––––––––––––––––––––
            preRxGS = gsTargetOut.Receptie.RxFeederLoss + ...
                      gsTargetOut.Receptie.InterferenceLoss + ...
                      gsTargetOut.Links.Downlink.RadomeLoss + ...
                      res2.PolarizationLoss;
            sysRxGS = preRxGS + gsTargetOut.Receptie.OtherRxLosses;

            gsTargetOutReceiver = receiver( ...
                gsTargetOutRxGimbal, ...
                'Name',                        'GS_Target_Rx', ...
                'RequiredEbNo',                gsTargetOut.Links.Downlink.RequiredEbByNo_dB, ...
                'GainToNoiseTemperatureRatio', gsTargetOut.Receptie.RxGByT, ...
                'PreReceiverLoss',             preRxGS, ...
                'SystemLoss',                  sysRxGS);
            gaussianAntenna(gsTargetOutReceiver, 'DishDiameter', Dsol);

            %––– 3) Satelit 1: Transmitter + Receiver –––––––––––––––––––––––––––––
            Dsat=1;
            eta = computeApertureEfficiency(Dsat, sat1Out.Emisie.TxAntennaGain, gsTargetOut.Links.Downlink.FrequencyGHz);
            display(eta);
            sysLossTxSat = sat1Out.Emisie.TxFeederLoss + ...
               sat1Out.Emisie.OtherTxLosses + ...
               gsTargetOut.Links.Downlink.RadomeLoss;

            sat1OutTransmitter = transmitter( ...
                sat1OutTxGimbal, ...
                'Name',       'SAT_Tx', ...
                'MountingLocation',[0;0;Dsat], ...
                'Frequency',  gsTargetOut.Links.Downlink.FrequencyGHz * 1e9, ...
                'Power',      sat1Out.Emisie.TxHPAPower - sat1Out.Emisie.TxHPAOBO, ...
                'SystemLoss', sysLossTxSat, ...
                'BitRate',    gsTargetOut.Links.Downlink.BitRateMbps);
                        gaussianAntenna(sat1OutTransmitter, ...
                            "DishDiameter", Dsat,....
                            "ApertureEfficiency", eta); % meters

            preRxSat = sat1Out.Receptie.RxFeederLoss + ...
                sat1Out.Receptie.InterferenceLoss + ...
                gsSourceOut.Links.Uplink.RadomeLoss + ...
                res1.PolarizationLoss;
            % SystemLoss adaugă și pierderile interne de Rx
            sysRxSat = preRxSat + sat1Out.Receptie.OtherRxLosses;

            sat1OutReceiver = receiver( ...
                sat1OutRxGimbal, ...
                'Name',                        'SAT_Rx', ...
                'RequiredEbNo',                gsSourceOut.Links.Uplink.RequiredEbByNo_dB, ...
                'GainToNoiseTemperatureRatio', sat1Out.Receptie.RxGByT, ...
                'PreReceiverLoss',             preRxSat, ...
                'SystemLoss',                  sysRxSat);
            gaussianAntenna(sat1OutReceiver, 'DishDiameter', Dsat);

            %% Ajustam orientarea
            pointAt(gsSourceOutTxGimbal,sat1Out.Object);
            pointAt(sat1OutRxGimbal,gsSourceOut.Object);
            pointAt(sat1OutTxGimbal,gsTargetOut.Object);
            pointAt(gsTargetOutRxGimbal,sat1Out.Object);
            %% Formam obiectul link
            lnk1 = link(gsSourceOutTransmitter,sat1OutReceiver);

            lnk2 = link(sat1OutTransmitter,gsTargetOutReceiver);
            
            lnk3=link(gsSourceOutTransmitter,sat1OutReceiver,sat1OutTransmitter,gsTargetOutReceiver);

            % --- 1) Pregătire date pentru cele 3 link-uri ---
            links    = {lnk1, lnk2, lnk3};
            reqEbNo  = [ ...
                sat1OutReceiver.RequiredEbNo, ...
                gsTargetOutReceiver.RequiredEbNo, ...
                gsTargetOutReceiver.RequiredEbNo ...
            ];
            TT       = cell(3,1);
            times    = cell(3,1);
            margins  = cell(3,1);
            for k = 1:3
                TT{k} = linkIntervals( links{k} );
                if istimetable(TT{k})
                    TT{k} = timetable2table(TT{k}, 'ConvertRowTimes', true);
                end
                [eb, t]     = ebno( links{k} );
                times{k}    = t;
                margins{k}  = eb - reqEbNo(k);
            end
            
            % --- 2) O singură fereastră maximizată cu 3 taburi ---
            fig = uifigure( ...
                'Name', 'Analiză Link-uri', ...
                'WindowState', 'maximized' ...
            );
            tg = uitabgroup(fig, ...
                'Units','normalized', ...
                'Position',[0 0 1 1] ...
            );
            
            % --- Tab 1: Tabele de Acces ---
            tab1 = uitab(tg, 'Title', 'Tabele de Acces');
            tblGL = uigridlayout(tab1, [3,1], ...
                'RowHeight',    {'1x','1x','1x'}, ...
                'Padding',      0, ...
                'RowSpacing',   0 ...
            );
            for k = 1:3
                tbl = uitable(tblGL, ...
                    'Data',       TT{k}, ...
                    'ColumnName', TT{k}.Properties.VariableNames, ...
                    'Units',      'normalized', ...
                    'Position',   [0 0 1 1] ...
                );
                tbl.Layout.Row    = k;
                tbl.Layout.Column = 1;
            end
            
            % --- Tab 2: Grafice (vertical) ---
            tab2 = uitab(tg, 'Title', 'Grafice');
            plotGL = uigridlayout(tab2, [2,1], ...
                'Padding',    [10 10 10 10], ...
                'RowSpacing', 20, ...
                'ColumnSpacing',0 ...
            );
            % Link 1 vs Link 2 (rândul 1)
            ax1 = uiaxes(plotGL);
            ax1.Layout.Row    = 1;
            ax1.Layout.Column = 1;
            hold(ax1,'on');
            plot(ax1, times{1}, margins{1}, 'LineWidth',2);
            plot(ax1, times{2}, margins{2}, 'LineWidth',2);
            hold(ax1,'off');
            legend(ax1, ...
                sprintf('%s → %s', gsSourceOutTransmitter.Name, sat1OutReceiver.Name), ...
                sprintf('%s → %s', sat1OutTransmitter.Name, gsTargetOutReceiver.Name), ...
                'Location','best' ...
            );
            title(ax1, 'Link 1 vs Link 2');
            xlabel(ax1, 'Time');
            ylabel(ax1, 'Link Margin (dB)');
            grid(ax1, 'on');
            
            % Link 3 (Cascadă) (rândul 2)
            ax2 = uiaxes(plotGL);
            ax2.Layout.Row    = 2;
            ax2.Layout.Column = 1;
            plot(ax2, times{3}, margins{3}, 'LineWidth',2);
            title(ax2, 'Link 3 (Cascadă)');
            xlabel(ax2, 'Time');
            ylabel(ax2, 'Link Margin (dB)');
            grid(ax2, 'on');
            
            % --- Tab 3: Bugetul de legătură (auto‐resize) ---
            tab3 = uitab(tg, 'Title', 'Bugetul de legătură');
            
            % 1×1 layout care umple întreg tab-ul
            tab3GL = uigridlayout(tab3, [1,1], ...
                'Padding',      0, ...
                'RowSpacing',   0, ...
                'ColumnSpacing',0, ...
                'RowHeight',    {'1x'}, ...
                'ColumnWidth',  {'1x'});
            
            % Definim coloanele și datele tabelului:
            colName   = {'Tag','Parametru','Uplink','Downlink'};
            colFormat = {'char','char','numeric','numeric'};
            colWidth  = {'1x','2x','1x','1x'};
            data = {
              'N1','Distance (km)',           res1.Distance,               res2.Distance;
              'N2','Elevation (deg)',         res1.Elevation,              res2.Elevation;
              'N3','Tx EIRP (dBW)',           res1.TxEIRP,                 res2.TxEIRP;
              'N4','Polarization loss (dB)',  res1.PolarizationLoss,       res2.PolarizationLoss;
              'N5','FSPL (dB)',               res1.FSPL,                   res2.FSPL;
              'N6','Recv. isotropic P (dBW)', res1.ReceivedIsotropicPower, res2.ReceivedIsotropicPower;
              'N7','Recv. power (dBm)',       res1.ReceivedPower,          res2.ReceivedPower;
              'N8','C/No (dB-Hz)',            res1.CNo,                    res2.CNo;
              'N9','C/N (dB)',                res1.CN,                     res2.CN;
              'N10','Eb/No (dB)',             res1.EbNo,                   res2.EbNo;
              'N11','Margin (dB)',            res1.Margin,                 res2.Margin
            };
            
            % Creăm uitable care umple celula layout-ului
            tbl3 = uitable(tab3GL, ...
                'Data',         data, ...
                'ColumnName',   colName, ...
                'ColumnFormat', colFormat, ...
                'ColumnWidth',  colWidth, ...
                'RowName',      {}, ...
                'FontSize',     14);
            tbl3.Layout.Row    = 1;
            tbl3.Layout.Column = 1;



        
            %% Helper: găsește indexul unui satelit în structura Constelatii
            function info = findSatelliteInConstellations(app, satObj)
                % FINDSATELLITEINCONSTELLATIONS Returnează indicii constelației și satelitului
                %   info.constIdx – indexul în app.Constelatii
                %   info.satIdx   – indexul în Sateliti al constelației găsite
            
                info.constIdx = [];
                info.satIdx   = [];
                for iConst = 1:numel(app.Constelatii)
                    sats = app.Constelatii(iConst).Sateliti;  % struct array
                    % comparăm handle-urile cu isequal
                    mask = arrayfun(@(s) isequal(s.Object, satObj), sats);
                    jSat = find(mask, 1);
                    if ~isempty(jSat)
                        info.constIdx = iConst;
                        info.satIdx   = jSat;
                        return;
                    end
                end
            end

            %% Funcție UI pentru editare parametri link
            function [gsSrcOut, sat1Out, gsTgtOut, success] = linkBudgetUI(gsSrcIn, sat1In, gsTgtIn)
                % Verificari campurile si le populam (doar dacă nu există sau sunt goale)
                % 1) Default‐uri compacte pentru fiecare tip de entitate
                d.gsTx = struct('Altitude',10,'TxFeederLoss',0.5,'OtherTxLosses',0.2,'TxHPAPower',55,'TxHPAOBO',2,'TxAntennaGain',40);
                d.gsRx = struct('Altitude',10,'InterferenceLoss',0.1,'RxGByT',30,'RxFeederLoss',0.2,'OtherRxLosses',0.1);
                d.satTx = struct('TxFeederLoss',0.1,'OtherTxLosses',0.2,'TxHPAPower',35,'TxHPAOBO',1,'TxAntennaGain',38);
                d.satRx = struct('InterferenceLoss',0.2,'RxGByT',20,'RxFeederLoss',0.2,'OtherRxLosses',0.1);
                d.linkU = struct('Frequency',14.25,'Bandwidth',36,'BitRate',10,'RequiredEbNo',3,'PolarizationMismatch',0.3,'ImplementationLoss',1,'AntennaMispointingLoss',0.5,'RadomeLoss',0.2);
                d.linkD = struct('Frequency',11.30,'Bandwidth',36,'BitRate',10,'RequiredEbNo',3,'PolarizationMismatch',0.3,'ImplementationLoss',1,'AntennaMispointingLoss',0.5,'RadomeLoss',0.2);
                %––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––%
                success=false;
                %––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––%
                % 2) Completează numai câmpurile relevante
                
                % Stația sursă: Emisie
                for fn = fieldnames(d.gsTx)'
                    f = fn{1};
                    if isempty(gsSrcIn.Emisie.(f))
                        gsSrcIn.Emisie.(f) = d.gsTx.(f);
                    end
                end
                
                % Sateliți: Emisie + Recepție
                for fn = fieldnames(d.satTx)'
                    f = fn{1};
                    if isempty(sat1In.Emisie.(f)), sat1In.Emisie.(f) = d.satTx.(f); end
                end
                for fn = fieldnames(d.satRx)'
                    f = fn{1};
                    if isempty(sat1In.Receptie.(f)), sat1In.Receptie.(f) = d.satRx.(f); end
                end
                
                % Stația țintă: Recepție
                for fn = fieldnames(d.gsRx)'
                    f = fn{1};
                    if isempty(gsTgtIn.Receptie.(f))
                        gsTgtIn.Receptie.(f) = d.gsRx.(f);
                    end
                end
              
                % 3) Pregătire link‐uri
                linkUIn = d.linkU;
                linkDIn = d.linkD;

                gsSrcIn.Links.Uplink   = struct( ...
                    'FrequencyGHz',            linkUIn.Frequency, ...
                    'BandwidthMHz',            linkUIn.Bandwidth, ...
                    'BitRateMbps',             linkUIn.BitRate, ...
                    'RequiredEbByNo_dB',       linkUIn.RequiredEbNo, ...
                    'PolarizationMismatch_deg',linkUIn.PolarizationMismatch, ...
                    'ImplementationLoss',      linkUIn.ImplementationLoss, ...
                    'AntennaMispointingLoss',  linkUIn.AntennaMispointingLoss, ...
                    'RadomeLoss',              linkUIn.RadomeLoss);
                
                gsTgtIn.Links.Downlink = struct( ...
                    'FrequencyGHz',            linkDIn.Frequency, ...
                    'BandwidthMHz',            linkDIn.Bandwidth, ...
                    'BitRateMbps',             linkDIn.BitRate, ...
                    'RequiredEbByNo_dB',       linkDIn.RequiredEbNo, ...
                    'PolarizationMismatch_deg',linkDIn.PolarizationMismatch, ...
                    'ImplementationLoss',      linkDIn.ImplementationLoss, ...
                    'AntennaMispointingLoss',  linkDIn.AntennaMispointingLoss, ...
                    'RadomeLoss',              linkDIn.RadomeLoss);
                
                gsSrcOut = gsSrcIn; sat1Out  = sat1In; gsTgtOut = gsTgtIn;
 
                %––– Construire figură și layout –––––––––––––––––––––––––––––––––––––––––%
                fig = uifigure('Name','Bugetul Legăturii','Position',[100 100 900 600]);
                gl = uigridlayout(fig, [3 3], 'Padding', 5);
                gl.RowSpacing    = 5;
                gl.ColumnSpacing = 5;
                gl.RowHeight     = {'1x','1x','fit'};   % ultimul rând pentru butoane
                gl.ColumnWidth   = {'1x','1x','1x'};
                
                %––– Panel Stație sursă (Emisie + poziție) –––––––––––––––––––––––––––––%
                p1 = uipanel(gl, 'Title',['Stație sursă: ' gsSrcIn.Name]);
                p1.Layout.Row    = 1; p1.Layout.Column = 1;
                g1 = uigridlayout(p1, [8 2]);
                uilabel(g1,'Text','Latitude (°)');         ef_lat1 = uieditfield(g1,'numeric','AllowEmpty', true,'Value',gsSrcIn.Latitude);
                uilabel(g1,'Text','Longitude (°)');        ef_lon1 = uieditfield(g1,'numeric','AllowEmpty', true,'Value',gsSrcIn.Longitude);
                uilabel(g1,'Text','Altitude (m)');         ef_alt1 = uieditfield(g1,'numeric','AllowEmpty', true,'Value',gsSrcIn.Emisie.Altitude);
                uilabel(g1,'Text','Tx feeder loss (dB)');  ef_txf1 = uieditfield(g1,'numeric','AllowEmpty', true,'Value',gsSrcIn.Emisie.TxFeederLoss);
                uilabel(g1,'Text','Other Tx losses (dB)'); ef_otx1 = uieditfield(g1,'numeric','AllowEmpty', true,'Value',gsSrcIn.Emisie.OtherTxLosses);
                uilabel(g1,'Text','HPA power (dBW)');      ef_hpa1 = uieditfield(g1,'numeric','AllowEmpty', true,'Value',gsSrcIn.Emisie.TxHPAPower);
                uilabel(g1,'Text','HPA OBO (dB)');         ef_obo1 = uieditfield(g1,'numeric','AllowEmpty', true,'Value',gsSrcIn.Emisie.TxHPAOBO);
                uilabel(g1,'Text','Antenna gain (dBi)');   ef_ag1  = uieditfield(g1,'numeric','AllowEmpty', true,'Value',gsSrcIn.Emisie.TxAntennaGain);
                
                %––– Panel Uplink ––––––––––––––––––––––––––––––––––––––––––––––––––––%
                p2 = uipanel(gl,'Title','Uplink');
                p2.Layout.Row    = 1; p2.Layout.Column = 2;
                g2 = uigridlayout(p2,[8 2]);
                uilabel(g2,'Text','Frequency (GHz)');             ef_f   = uieditfield(g2,'numeric','AllowEmpty',true,'Value',linkUIn.Frequency);
                uilabel(g2,'Text','Bandwidth (MHz)');             ef_b   = uieditfield(g2,'numeric','AllowEmpty',true,'Value',linkUIn.Bandwidth);
                uilabel(g2,'Text','Bit rate (Mbps)');             ef_br  = uieditfield(g2,'numeric','AllowEmpty',true,'Value',linkUIn.BitRate);
                uilabel(g2,'Text','Required Eb/No (dB)');         ef_e   = uieditfield(g2,'numeric','AllowEmpty',true,'Value',linkUIn.RequiredEbNo);
                uilabel(g2,'Text','Polarization mismatch (deg)'); ef_pm  = uieditfield(g2,'numeric','AllowEmpty',true,'Value',linkUIn.PolarizationMismatch);
                uilabel(g2,'Text','Implementation loss (dB)');    ef_il  = uieditfield(g2,'numeric','AllowEmpty',true,'Value',linkUIn.ImplementationLoss);
                uilabel(g2,'Text','Antenna mispointing loss (dB)'); ef_ml = uieditfield(g2,'numeric','AllowEmpty',true,'Value',linkUIn.AntennaMispointingLoss);
                uilabel(g2,'Text','Radome loss (dB)');             ef_rl = uieditfield(g2,'numeric','AllowEmpty',true,'Value',linkUIn.RadomeLoss);

                %––– Panel Recepție Sat ––––––––––––––––––––––––––––––––––––––––––––%
                p3 = uipanel(gl,'Title',['Recepție: ' char(sat1In.Nume)]);
                p3.Layout.Row    = 1; p3.Layout.Column = 3;
                g3 = uigridlayout(p3,[8 2]);
                uilabel(g3,'Text','Interference loss (dB)'); ef_il3 = uieditfield(g3,'numeric','AllowEmpty', true,'Value',sat1In.Receptie.InterferenceLoss);
                uilabel(g3,'Text','Rx G/T (dB/K)');         ef_gt3 = uieditfield(g3,'numeric','AllowEmpty', true,'Value',sat1In.Receptie.RxGByT);
                uilabel(g3,'Text','Rx feeder loss (dB)');   ef_rf3 = uieditfield(g3,'numeric','AllowEmpty', true,'Value',sat1In.Receptie.RxFeederLoss);
                uilabel(g3,'Text','Other Rx losses (dB)');  ef_or3 = uieditfield(g3,'numeric','AllowEmpty', true,'Value',sat1In.Receptie.OtherRxLosses);
                
                %––– Panel Emisie Sat ––––––––––––––––––––––––––––––––––––––––––––––%
                p4 = uipanel(gl,'Title',['Emisie: ' char(sat1In.Nume)]);
                p4.Layout.Row    = 2; p4.Layout.Column = 1;
                g4 = uigridlayout(p4,[5 2]);
                uilabel(g4,'Text','Tx feeder loss (dB)');   ef_txf2 = uieditfield(g4,'numeric','AllowEmpty', true,'Value',sat1In.Emisie.TxFeederLoss);
                uilabel(g4,'Text','Other Tx losses (dB)');  ef_otx2 = uieditfield(g4,'numeric','AllowEmpty', true,'Value',sat1In.Emisie.OtherTxLosses);
                uilabel(g4,'Text','HPA power (dBW)');       ef_hpa2 = uieditfield(g4,'numeric','AllowEmpty', true,'Value',sat1In.Emisie.TxHPAPower);
                uilabel(g4,'Text','HPA OBO (dB)');          ef_obo2 = uieditfield(g4,'numeric','AllowEmpty', true,'Value',sat1In.Emisie.TxHPAOBO);
                uilabel(g4,'Text','Antenna gain (dBi)');    ef_ag2  = uieditfield(g4,'numeric','AllowEmpty', true,'Value',sat1In.Emisie.TxAntennaGain);
                
                %––– Panel Downlink –––––––––––––––––––––––––––––––––––––––––––––––––%
                p5 = uipanel(gl,'Title','Downlink');
                p5.Layout.Row    = 2; p5.Layout.Column = 2;
                g5 = uigridlayout(p5,[3 2]);
                uilabel(g5,'Text','Frequency (GHz)');             ef_fd  = uieditfield(g5,'numeric','AllowEmpty',true,'Value',linkDIn.Frequency);
                uilabel(g5,'Text','Bandwidth (MHz)');             ef_bd  = uieditfield(g5,'numeric','AllowEmpty',true,'Value',linkDIn.Bandwidth);
                uilabel(g5,'Text','Bit rate (Mbps)');             ef_brD = uieditfield(g5,'numeric','AllowEmpty',true,'Value',linkDIn.BitRate);
                uilabel(g5,'Text','Required Eb/No (dB)');         ef_ed  = uieditfield(g5,'numeric','AllowEmpty',true,'Value',linkDIn.RequiredEbNo);
                uilabel(g5,'Text','Polarization mismatch (deg)'); ef_pmd = uieditfield(g5,'numeric','AllowEmpty',true,'Value',linkDIn.PolarizationMismatch);
                uilabel(g5,'Text','Implementation loss (dB)');    ef_ild = uieditfield(g5,'numeric','AllowEmpty',true,'Value',linkDIn.ImplementationLoss);
                uilabel(g5,'Text','Antenna mispointing loss (dB)'); ef_mld= uieditfield(g5,'numeric','AllowEmpty',true,'Value',linkDIn.AntennaMispointingLoss);
                uilabel(g5,'Text','Radome loss (dB)');             ef_rld = uieditfield(g5,'numeric','AllowEmpty',true,'Value',linkDIn.RadomeLoss);
                
                %––– Panel Stație țintă (Recepție + poziție) ––––––––––––––––––––––––––
                p6 = uipanel(gl,'Title',['Stație destinație: ' gsTgtIn.Name]);
                p6.Layout.Row    = 2; p6.Layout.Column = 3;
                g6 = uigridlayout(p6,[7 2]);
                uilabel(g6,'Text','Latitude (°)');          ef_lat4 = uieditfield(g6,'numeric','AllowEmpty', true,'Value',gsTgtIn.Latitude);
                uilabel(g6,'Text','Longitude (°)');         ef_lon4 = uieditfield(g6,'numeric','AllowEmpty', true,'Value',gsTgtIn.Longitude);
                uilabel(g6,'Text','Altitude (m)');          ef_alt4 = uieditfield(g6,'numeric','AllowEmpty', true,'Value',gsTgtIn.Receptie.Altitude);
                uilabel(g6,'Text','Interference loss (dB)');ef_il4  = uieditfield(g6,'numeric','AllowEmpty', true,'Value',gsTgtIn.Receptie.InterferenceLoss);
                uilabel(g6,'Text','Rx G/T (dB/K)');         ef_gt4  = uieditfield(g6,'numeric','AllowEmpty', true,'Value',gsTgtIn.Receptie.RxGByT);
                uilabel(g6,'Text','Rx feeder loss (dB)');   ef_rf4  = uieditfield(g6,'numeric','AllowEmpty', true,'Value',gsTgtIn.Receptie.RxFeederLoss);
                uilabel(g6,'Text','Other Rx losses (dB)');  ef_or4  = uieditfield(g6,'numeric','AllowEmpty', true,'Value',gsTgtIn.Receptie.OtherRxLosses);
                
                %––– Butoane Aplica/Renunta –––––––––––––––––––––––––––––––––––––––––––%
                btnA = uibutton(gl,'Text','Aplica','ButtonPushedFcn',@onApply);
                btnA.Layout.Row    = 3;
                btnA.Layout.Column = 2;
                
                btnC = uibutton(gl,'Text','Renunta','ButtonPushedFcn',@onCancel);
                btnC.Layout.Row    = 3;
                btnC.Layout.Column = 3;

                uiwait(fig);
            
                % Only fall back to the original inputs if the user canceled:
                if ~success
                    gsSrcOut = gsSrcIn; sat1Out  = sat1In; gsTgtOut = gsTgtIn;
                end
            
                function onApply(~, ~)
                    %––– Preia valori Stație Sursă –––––––––––––––––––––––––––––––––––––––––
                    gsSrcOut.Latitude         = ef_lat1.Value;
                    gsSrcOut.Longitude        = ef_lon1.Value;
                    gsSrcOut.Emisie.Altitude  = ef_alt1.Value;
                    gsSrcOut.Emisie.TxFeederLoss  = ef_txf1.Value;
                    gsSrcOut.Emisie.OtherTxLosses = ef_otx1.Value;
                    gsSrcOut.Emisie.TxHPAPower    = ef_hpa1.Value;
                    gsSrcOut.Emisie.TxHPAOBO      = ef_obo1.Value;
                    gsSrcOut.Emisie.TxAntennaGain = ef_ag1.Value;
                
                    %––– Preia valori Uplink –––––––––––––––––––––––––––––––––––––––––––––
                    gsSrcOut.Links.Uplink.Frequency    = ef_f.Value;
                    gsSrcOut.Links.Uplink.Bandwidth    = ef_b.Value;
                    gsSrcOut.Links.Uplink.BitRate   = ef_br.Value;
                    gsSrcOut.Links.Uplink.RequiredEbNo = ef_e.Value;
                    gsSrcOut.Links.Uplink.PolarizationMismatch = ef_pm.Value;
                    gsSrcOut.Links.Uplink.ImplementationLoss   = ef_il.Value;
                    gsSrcOut.Links.Uplink.AntennaMispointingLoss = ef_ml.Value;
                    gsSrcOut.Links.Uplink.RadomeLoss           = ef_rl.Value;
                    
                    %––– Preia valori Recepție Sat1 –––––––––––––––––––––––––––––––––––––––
                    sat1Out.Receptie.InterferenceLoss = ef_il3.Value;
                    sat1Out.Receptie.RxGByT           = ef_gt3.Value;
                    sat1Out.Receptie.RxFeederLoss     = ef_rf3.Value;
                    sat1Out.Receptie.OtherRxLosses    = ef_or3.Value;
                
                    %––– Preia valori Emisie Sat2 ––––––––––––––––––––––––––––––––––––––––
                    sat1Out.Emisie.TxFeederLoss   = ef_txf2.Value;
                    sat1Out.Emisie.OtherTxLosses  = ef_otx2.Value;
                    sat1Out.Emisie.TxHPAPower     = ef_hpa2.Value;
                    sat1Out.Emisie.TxHPAOBO       = ef_obo2.Value;
                    sat1Out.Emisie.TxAntennaGain  = ef_ag2.Value;
                
                    %––– Preia valori Downlink ––––––––––––––––––––––––––––––––––––––––––
                    gsTgtOut.Links.Downlink.Frequency            = ef_fd.Value;
                    gsTgtOut.Links.Downlink.Bandwidth            = ef_bd.Value;
                    gsTgtOut.Links.Downlink.BitRate              = ef_brD.Value;
                    gsTgtOut.Links.Downlink.RequiredEbNo         = ef_ed.Value;
                    gsTgtOut.Links.Downlink.PolarizationMismatch = ef_pmd.Value;
                    gsTgtOut.Links.Downlink.ImplementationLoss   = ef_ild.Value;
                    gsTgtOut.Links.Downlink.AntennaMispointingLoss = ef_mld.Value;
                    gsTgtOut.Links.Downlink.RadomeLoss           = ef_rld.Value;
                
                    %––– Preia valori Stație Țintă –––––––––––––––––––––––––––––––––––––––
                    gsTgtOut.Latitude                    = ef_lat4.Value;
                    gsTgtOut.Longitude                   = ef_lon4.Value;
                    gsTgtOut.Receptie.Altitude           = ef_alt4.Value;
                    gsTgtOut.Receptie.InterferenceLoss   = ef_il4.Value;
                    gsTgtOut.Receptie.RxGByT             = ef_gt4.Value;
                    gsTgtOut.Receptie.RxFeederLoss       = ef_rf4.Value;
                    gsTgtOut.Receptie.OtherRxLosses      = ef_or4.Value;
                    %––– Finalizare ––––––––––––––––––––––––––––––––––––––––––––––––––––––
                    success = true;
                    uiresume(fig);
                    delete(fig);
                end

                function onCancel(~,~)
                    success = false;
                    uiresume(fig);
                    delete(fig);
                end
            end

            function satBest = selectBestRelaySatellite(gs1, gs2, satArray, refTime)
                %SELECTBESTREPLAYSATELLITE Pick the single best sat by minimizing path length
                %   satBest = selectBestRelaySatellite(gs1, gs2, satArray, refTime)
                %   returns the satellite from satArray that minimizes the sum of
                %   the two slant ranges [gs1→sat + sat→gs2], subject to both
                %   elevations exceeding the mask angle.
                
                    % 1) Minimum elevation (deg) to consider usable
                    elMin = 10;
                
                    % 2) Compute elevation & slant-range from each GS
                    [~, el1, r1] = aer(gs1, satArray, refTime);
                    [~, el2, r2] = aer(gs2, satArray, refTime);
                
                    % 3) Only keep sats that clear the mask at both ends
                    mask = (el1 >= elMin) & (el2 >= elMin);
                    idx  = find(mask);
                    if isempty(idx)
                        satBest = 0;
                        return;
                    end
                
                    % 4) Compute total path length and pick satellite with minimal sum
                    totalRange = r1(idx) + r2(idx);
                    [~, bestRel] = min(totalRange);
                
                    % 5) Return the best satellite handle
                    satBest = satArray(idx(bestRel));
            end
           
            function eta = computeApertureEfficiency(D, gain_dBi, freq_GHz)
                % Calculează eficiența unei antene parabolice
                %   eta = COMPUTEAPERTUREEFFICIENCY(D, gain_dBi, freq_GHz) returnează
                %   factorul de eficiență η (≤1) pentru un reflector circular de diametru D (m),
                %   dat fiind un câștig dorit gain_dBi (dBi) la frecvența freq_GHz (GHz).
                %
                %   Formula de bază:
                %     G_linear = 10^(gain_dBi/10)
                %     A_phys    = π*(D/2)^2
                %     η = A_eff / A_phys,  cu A_eff = (λ^2/(4π)) * G_linear  :contentReference[oaicite:0]{index=0}
               
                %   Intrările:
                %     D         – diametrul parabolei (m)
                %     gain_dBi  – câștigul dorit (dBi)
                %     freq_GHz  – frecvența de operare (GHz)
                %
                %   Ieșirea:
                %     eta       – eficiența antenei (unitless, în interval [0,1])
                
                    % Constanta vitezei luminii
                    c = physconst('LightSpeed');  % [m/s]
                    
                    % Convertim frecvența și câștigul
                    f_Hz    = freq_GHz * 1e9;               % [Hz]
                    lambda  = c ./ f_Hz;                     % lungimea de undă [m]
                    G_lin   = 10^(gain_dBi/10);             % câștig liniar
                
                    % Calculăm eficiența
                    eta_calc = G_lin ./ ( (pi * D ./ lambda)^2 );  % :contentReference[oaicite:2]{index=2}
                
                    % Limităm eficiența la maxim 1
                    eta = min(eta_calc, 1);
            end
            
            function res = calculateLinkBudget(emParams, recParams, linkParams, elevation_deg, range_m)
                % CALCULATELINKBUDGET Compute full satellite link‐budget metrics
                %
                % INPUTS:
                %   emParams: struct with fields
                %     .TxHPAPower       – [dBW] HPA output power
                %     .TxHPAOBO         – [dB] HPA output back-off
                %     .TxFeederLoss     – [dB] transmitter feeder losses
                %     .OtherTxLosses    – [dB] other transmitter losses
                %     .TxAntennaGain    – [dBi] transmit antenna gain
                %
                %   recParams: struct with fields
                %     .RxGByT           – [dB/K] receiver G/T
                %     .RxFeederLoss     – [dB] receiver feeder losses
                %     .OtherRxLosses    – [dB] other receiver losses
                %     .InterferenceLoss – [dB] external interference losses
                %
                %   linkParams: struct with fields
                %     .FrequencyGHz             – [GHz]
                %     .BandwidthMHz             – [MHz]
                %     .BitRateMbps              – [Mbps]
                %     .RequiredEbByNo_dB        – [dB]
                %     .PolarizationMismatch_deg – [deg]
                %     .ImplementationLoss       – [dB]
                %     .AntennaMispointingLoss   – [dB]
                %     .RadomeLoss               – [dB]
                %
                %   elevation_deg   – [deg] elevation angle
                %   range_m         – [m]  slant range
                %
                % OUTPUT:
                %   res: struct with fields
                %     Distance                 [km]
                %     Elevation                [deg]
                %     TxEIRP                   [dBW]
                %     PolarizationLoss         [dB]
                %     FSPL                     [dB]
                %     ReceivedIsotropicPower   [dBW]
                %     ReceivedPower            [dBm]
                %     CNo                      [dB-Hz]
                %     CN                       [dB]
                %     EbNo                     [dB]
                %     Margin                   [dB]
                
                    % 1) Distance [km]
                    res.Distance = range_m / 1e3;
                
                    % 2) Elevation [deg]
                    res.Elevation = elevation_deg;
                
                    % 3) Transmit EIRP [dBW]
                    %   EIRP = HPA_out - OBO - feeder_losses - other_tx_losses + antenna_gain - radome_loss
                    res.TxEIRP = emParams.TxHPAPower ...
                               - emParams.TxHPAOBO ...
                               - emParams.TxFeederLoss ...
                               - emParams.OtherTxLosses ...
                               + emParams.TxAntennaGain ...
                               - linkParams.RadomeLoss;
                
                    % 4) Polarization mismatch loss [dB]
                    res.PolarizationLoss = 20 * abs(log10(cosd(linkParams.PolarizationMismatch_deg)));
                
                    % 5) Free‐space path loss FSPL [dB]
                    c      = physconst('LightSpeed');
                    freqHz = linkParams.FrequencyGHz * 1e9;
                    lambda = c / freqHz;
                    res.FSPL = 20*log10(4*pi*range_m / lambda);
                
                    % 6) Received isotropic power [dBW]
                    %   P_iso = EIRP - polarization - FSPL - interference - mispointing
                    res.ReceivedIsotropicPower = res.TxEIRP ...
                                               - res.PolarizationLoss ...
                                               - res.FSPL ...
                                               - recParams.InterferenceLoss ...
                                               - linkParams.AntennaMispointingLoss;
                
                    % 7) Received power at LNA input [dBm]
                    %   add Rx antenna gain via G/T conversion: P_rx = P_iso + G/T + 10*log10(k*T_sys) - losses + 30
                    k_dBW = 10*log10(physconst('Boltzmann'));  % Boltzmann constant [dBW/K/Hz]
                    T_sys = 290;                               % assume 290 K system temp unless provided
                    % convert dBW to dBm: +30
                    res.ReceivedPower = res.ReceivedIsotropicPower ...
                                      + recParams.RxGByT ...
                                      - (k_dBW + 10*log10(T_sys)) ...
                                      - recParams.RxFeederLoss ...
                                      - recParams.OtherRxLosses ...
                                      + 30;
                
                    % 8) Carrier‐to‐noise density C/No [dB-Hz]
                    %   C/No = P_iso + G/T - k_dBW - receiver_losses
                    res.CNo = res.ReceivedIsotropicPower ...
                            + recParams.RxGByT ...
                            - k_dBW ...
                            - recParams.RxFeederLoss ...
                            - recParams.OtherRxLosses;
                
                    % 9) Carrier‐to‐noise ratio C/N [dB]
                    %   subtract 10*log10(BW_Hz)
                    res.CN = res.CNo - (10*log10(linkParams.BandwidthMHz*1e6));
                
                    % 10) Energy‐per‐bit to noise ratio Eb/No [dB]
                    %    Eb/No = C/No - 10*log10(BitRate_Hz)
                    res.EbNo = res.CNo - 10*log10(linkParams.BitRateMbps*1e6);
                
                    % 11) Link margin [dB]
                    res.Margin = res.EbNo ...
                               - linkParams.RequiredEbByNo_dB ...
                               - linkParams.ImplementationLoss;
                end
                




          
        end

        % Callback function
        function AnalizaAnteneiButtonPushed(app, event)

        end

        % Button pushed function: PorneteButton
        function PorneteButtonPushed(app, event)
            if ~isempty(app.sc) && isvalid(app.sc)
                % Pornește simularea
                app.sc.AutoSimulate = true;
                play(app.sc);
                updateStatus(app, 'Simularea a fost pornită.');
            else
                uialert(app.UIFigure, 'Scenariul nu este inițializat!', 'Eroare');
            end
        end

        % Button pushed function: OpreteButton
        function OpreteButtonPushed2(app, event)
             if ~isempty(app.sc) && isvalid(app.sc)
                % Pune simularea pe pauză: oprește actualizarea
                app.sc.AutoSimulate = false;
                % Actualizează statusul pentru a informa utilizatorul
                updateStatus(app, 'Simularea a fost pusă pe pauză. Fereastra de vizualizare nu se va actualiza.');
            else
                uialert(app.UIFigure, 'Scenariul nu este inițializat!', 'Eroare');
            end
        end

        % Button pushed function: ConectareButton
        function ConectareButtonPushed(app, event)
            if isempty(app.sc) || ~isvalid(app.sc)
                uialert(app.UIFigure, 'Scenariul nu este inițializat.', 'Eroare');
                return;
            end
        
            if ~app.sc.AutoSimulate
                app.sc.AutoSimulate = true;
                pause(0.5);
            end

            % Reset accumulated intervals when starting a new connection
            clear showConnectivity;
            %% 2. Ask the User for the Calculation Mode (Single or Periodic)
            modDlg = uifigure('Name', 'Alegere Mod Calcul', 'Position', [500 400 400 200]);
            currentTimeStr = datestr(app.v.CurrentTime, 'HH:MM:SS');
            uilabel(modDlg, 'Text', sprintf('Timp curent: %s', currentTimeStr), ...
                    'Position', [50 150 300 22], 'FontWeight', 'bold');
            uilabel(modDlg, 'Text', 'Alegeți modul de calcul:', ...
                    'Position', [50 110 150 22]);
            uibutton(modDlg, 'Text', 'Calcul unic la timpul curent', ...
                    'Position', [50 70 300 30], 'ButtonPushedFcn', @(~,~) selectModUnic());
            uibutton(modDlg, 'Text', 'Recalculare periodică a drumului', ...
                    'Position', [50 30 300 30], 'ButtonPushedFcn', @(~,~) selectModRecalculare());
        
            % Local variables
            startTime = [];          % To be set from app.v.CurrentTime
            durataConexiune = 60;    % Connection duration (in minutes; user-specified)
            isMultipluMode = false;  % Default to single calculation
            connectivityFig = [];    % For connectivity results
            progressFig = [];        % Progress dialog handle
        
            uiwait(modDlg);
            if isempty(startTime)
                return;
            end
        
            % Define overall connection period
            stopTime = startTime + minutes(durataConexiune);
            globalStartTime = startTime;      % Save initial connection start time
            currentSegmentStart = startTime;  % Initialize current segment start time
            idxSource = app.StaiesursDropDown.Value;
            idxTarget = app.StaiedestinaieDropDown.Value;
            if isempty(idxSource) || isempty(idxTarget) || (idxSource == idxTarget)
                uialert(app.UIFigure, 'Selectați două stații de sol diferite.', 'Eroare');
                return;
            end
            gsSource = app.GroundStations(idxSource).Object;
            gsTarget = app.GroundStations(idxTarget).Object;
        
            if isempty(app.satelitiobj)
                uialert(app.UIFigure, 'Vectorul de sateliți este gol. Încărcați fișierul TLE și adăugați sateliții.', 'Eroare');
                return;
            end
            if iscell(app.satelitiobj)
                app.satelitiobj = [app.satelitiobj{:}];
            end
            satVector = app.satelitiobj;
            %% 5. Create Progress Dialog and Calculate Path
            if isMultipluMode
                progressFig = showProgressDialog('Recalculare drum');
            else
                progressFig = showProgressDialog('Verificare conexiune');
            end
        
            % Start calculation with the current segment start time
            calculateAndDisplayPath(currentSegmentStart);

            % --- Single Calculation Mode Callback ---
            function selectModUnic()
                isMultipluMode = false;
                if isprop(app.v, 'CurrentTime')
                    startTime = app.v.CurrentTime;
                else
                    delete(app.v);
                    app.v = satelliteScenarioViewer(app.sc, "ShowDetails", false);
                    startTime = app.v.CurrentTime;
                end
                delete(modDlg);
                durataConexiune = 60;  % Default duration for single calculation
                pause(0.5);
            end
        
            % --- Periodic Calculation Mode Callback ---
            function selectModRecalculare()
                isMultipluMode = true;
                delete(modDlg);
                configDlg = uifigure('Name', 'Configurare Recalculare', 'Position', [500 400 400 250]);
                currentTimeStr = datestr(app.v.CurrentTime, 'HH:MM:SS');
                uilabel(configDlg, 'Text', sprintf('Timp curent: %s', currentTimeStr), ...
                        'Position', [50 200 300 22], 'FontWeight', 'bold');
                uilabel(configDlg, 'Text', 'Durata conexiunii (minute):', 'Position', [50 150 180 22]);
                durataField = uieditfield(configDlg, 'numeric', 'Value', 60, 'Position', [260 150 80 22]);
                confirmBtn = uibutton(configDlg, 'Text', 'Confirm', 'Position', [150 40 100 30]);
                confirmBtn.ButtonPushedFcn = @(~,~) onConfirmRecalculare();
                uiwait(configDlg);
                
                function onConfirmRecalculare()
                    if isprop(app.v, 'CurrentTime')
                        startTime = app.v.CurrentTime;
                    else
                        delete(app.v);
                        app.v = satelliteScenarioViewer(app.sc, "ShowDetails", false);
                        startTime = app.v.CurrentTime;
                    end
                    try
                        durataConexiune = durataField.Value;
                    catch
                        durataConexiune = get(durataField, 'Value');
                    end
                    if isnan(durataConexiune) || durataConexiune <= 0
                        uialert(configDlg, 'Introduceți o durată validă pentru conexiune.', 'Eroare');
                        return;
                    end
                    delete(configDlg);
                end
            end
        
            % --- Cancel Calculation Callback ---
            function cancelCalculation()
                closeProgressDialog(progressFig);
                uialert(app.UIFigure, 'Calculul a fost anulat de utilizator.', 'Informație', 'Icon', 'info');
                return
            end
        
            % --- Show Progress Dialog ---
            function pf = showProgressDialog(titleText)
                pf = uifigure('Name', titleText, 'Position', [500 300 400 180]);
                gl = uigridlayout(pf, [4, 1]);
                gl.RowHeight = {'1x', '1x', '1x', 'fit'};
                
                progLabel = uilabel(gl, 'Text', 'Inițializare...', 'FontWeight', 'bold');
                progLabel.Layout.Row = 1;
                progLabel.Layout.Column = 1;
                
                bgPanel = uipanel(gl);
                bgPanel.Layout.Row = 2;
                bgPanel.Layout.Column = 1;
                bgPanel.BackgroundColor = [0.9 0.9 0.9];
                
                progFill = uilabel(bgPanel, 'Text', '');
                progFill.BackgroundColor = [0 0.447 0.741];
                progFill.Position = [0 0 1, bgPanel.Position(4)];
                
                percLabel = uilabel(gl, 'Text', '0%', 'HorizontalAlignment', 'center');
                percLabel.Layout.Row = 3;
                percLabel.Layout.Column = 1;
                
                cancelBtn = uibutton(gl, 'Text', 'Anulează Calculul', 'ButtonPushedFcn', @(src, event) cancelCalculation());
                cancelBtn.Layout.Row = 4;
                cancelBtn.Layout.Column = 1;
                
                setappdata(pf, 'ProgLabel', progLabel);
                setappdata(pf, 'ProgFill', progFill);
                setappdata(pf, 'PercLabel', percLabel);
                setappdata(pf, 'MaxWidth', 360);
            end
        
            % --- Update Progress Dialog ---
            function updateProgress(pf, value, message)
                if isempty(pf) || ~isvalid(pf)
                    return;
                end
                progLabel = getappdata(pf, 'ProgLabel');
                progFill = getappdata(pf, 'ProgFill');
                percLabel = getappdata(pf, 'PercLabel');
                maxWidth = getappdata(pf, 'MaxWidth');
                
                progLabel.Text = message;
                percLabel.Text = sprintf('%.0f%%', value * 100);
                newWidth = max(1, round(maxWidth * value));
                pos = progFill.Position;
                progFill.Position = [pos(1), pos(2), newWidth, pos(4)];
                drawnow;
            end
        
            % --- Close Progress Dialog ---
            function closeProgressDialog(pf)
                if ~isempty(pf) && isvalid(pf)
                    delete(pf);
                end
            end
        
            % --- Calculate and Display the Multi-hop Path & Check Access ---
            function calculateAndDisplayPath(segStart)
                % Use the segment start time for calculation.
                if segStart >= stopTime
                    finalizeCalculation(segStart);
                    return;
                end
                
                currentCalcTime = segStart;
                fprintf('DEBUG: currentCalcTime = %s\n', datestr(currentCalcTime, 'HH:MM:SS'));
                
                % Update overall progress based on globalStartTime (unchanged) and stopTime.
                progressValue = min(1, (datenum(currentCalcTime) - datenum(globalStartTime)) / (datenum(stopTime) - datenum(globalStartTime)));
                updateProgress(progressFig, progressValue, sprintf('Recalculare (%s)...', datestr(currentCalcTime, 'HH:MM:SS')));
                
                try
                    updateProgress(progressFig, 0.5, 'Calculare drum multihop...');
                    nodes = computeMultiHopPath(gsSource, gsTarget, satVector, currentCalcTime);
                    % Check if a valid multi-hop path was computed.
                    if isempty(nodes)
                        fprintf('DEBUG: No valid multi-hop path found at %s.\n', datestr(currentCalcTime, 'HH:MM:SS'));
                        if ~isMultipluMode
                            closeProgressDialog(progressFig);
                            uialert(app.UIFigure, 'Nu s-a găsit o cale validă la timpul curent.', 'Avertisment', 'Icon', 'warning');
                            return;
                        end
                        calculateAndDisplayPath(currentCalcTime+seconds(30));
                    else
                        updateProgress(progressFig, 0.8, 'Creare obiecte de acces și calcul intervale...');
                        ac = access(nodes{:});
                        ac.LineColor = "green";
                        intvls1 = accessIntervals(ac);
                        fprintf('DEBUG: Received intervals:\n');
                        disp(intvls1);
                        
                        % Filter intervals for the current segment [segStart, stopTime]
                        intvls = filterIntervals(intvls1, segStart, stopTime);
                        fprintf('DEBUG: Filtered intervals:\n');
                        disp(intvls);
                        connectivityFig = showConnectivity(intvls1, idxSource, idxTarget, globalStartTime, stopTime, connectivityFig);
                        
                        if ~isMultipluMode
                            closeProgressDialog(progressFig);
                        end
                        
                        if isMultipluMode
                            if ~isempty(intvls)
                                if istable(intvls) && ismember('EndTime', intvls.Properties.VariableNames)
                                    segEnd = max(intvls.EndTime);
                                elseif isdatetime(intvls) && size(intvls,2)==2
                                    segEnd = max(intvls(:,2));
                                else
                                    segEnd = currentCalcTime;
                                end
                                fprintf('DEBUG: Segment end time = %s\n', datestr(segEnd, 'HH:MM:SS'));
                                
                                if segEnd < stopTime
                                    fprintf('DEBUG: Current segment connection is not enough, attempting to recalculate path from segment end time.\n');
                                    calculateAndDisplayPath(segEnd+minutes(3)+seconds(30));
                                else
                                    fprintf('DEBUG: Connection covers up to or beyond stopTime. No further recalculation needed.\n');
                                    closeProgressDialog(progressFig);
                                    uialert(app.UIFigure, 'Conectarea a fost realizată.', 'Informație', 'Icon', 'info');
                                end
                            else
                                fprintf('DEBUG: No access intervals computed; not scheduling further recalculation.\n');
                                closeProgressDialog(progressFig);
                                uialert(app.UIFigure, 'Nu s-a găsit o cale validă pentru acest interval.', 'Avertisment', 'Icon', 'warning');

                            end
                        end
                    end
               catch ME
                    closeProgressDialog(progressFig);
                    fprintf('DEBUG: Error in calculateAndDisplayPath: %s\n', ME.message);
                    uialert(app.UIFigure, ['Eroare la calcularea drumului: ' ME.message], 'Eroare');
                end
            end
        
            % --- Finalize Calculation ---
            function finalizeCalculation(finalTime)
                fprintf('DEBUG: Finalizing calculation at %s\n', datestr(finalTime, 'HH:MM:SS'));
                nodesFinal = computeMultiHopPath(gsSource, gsTarget, satVector, finalTime);
                acFinal = access(nodesFinal{:});
                acFinal.LineColor = "magenta";  % Final snapshot styling
                finalIntvls = accessIntervals(acFinal);
                finalIntvls = filterIntervals(finalIntvls, globalStartTime, stopTime);
                connectivityFig = showConnectivity(finalIntvls, idxSource, idxTarget, globalStartTime, stopTime, connectivityFig);
                closeProgressDialog(progressFig);
                uialert(app.UIFigure, 'Perioada de conexiune a expirat. Calea finală a fost calculată.', 'Informație', 'Icon', 'info');
            end
        
            % --- Filter Intervals to the Connection Duration ---
            function filteredIntvls = filterIntervals(intvls, conStart, conStop)
                fprintf('DEBUG: In filterIntervals - conStart: %s, conStop: %s\n', datestr(conStart), datestr(conStop));
                if istable(intvls) && all(ismember({'StartTime','EndTime'}, intvls.Properties.VariableNames))
                    st = intvls.StartTime;
                    et = intvls.EndTime;
                    fprintf('DEBUG: Interval table size: %d rows\n', height(intvls));
                elseif isdatetime(intvls) && size(intvls,2) == 2
                    st = intvls(:,1);
                    et = intvls(:,2);
                    fprintf('DEBUG: Datetime array size: %d rows\n', size(intvls,1));
                else
                    fprintf('DEBUG: intvls has unexpected type: %s\n', class(intvls));
                    filteredIntvls = intvls;
                    return;
                end
                
                newSt = max(st, conStart);
                newEt = min(et, conStop);
                valid = newEt > newSt;  % Only intervals with positive duration.
                fprintf('DEBUG: %d intervals valid after filtering\n', sum(valid));
                if istable(intvls)
                    filteredIntvls = intvls(valid,:);
                    filteredIntvls.StartTime = newSt(valid);
                    filteredIntvls.EndTime = newEt(valid);
                else
                    filteredIntvls = [newSt(valid), newEt(valid)];
                end
            end
        
            % --- Show Connectivity Intervals ---
            function cf = showConnectivity(intvls, idxSource, idxTarget, conStart, conStop, cf)
                % Use a persistent variable to accumulate intervals over time.
                persistent accIntervals;
                if isempty(accIntervals)
                    accIntervals = intvls;
                else
                    if ~isempty(intvls)
                        if istable(intvls) && istable(accIntervals)
                            % Append the new intervals
                            accIntervals = [accIntervals; intvls];
                            % Remove duplicate rows and sort by StartTime.
                            accIntervals = unique(accIntervals, 'rows');
                            accIntervals = sortrows(accIntervals, 'StartTime');
                        elseif isdatetime(intvls) && isdatetime(accIntervals)
                            accIntervals = [accIntervals; intvls];
                            % Remove duplicate rows
                            accIntervals = unique(accIntervals, 'rows');
                            [~, order] = sort(datenum(accIntervals(:,1)));
                            accIntervals = accIntervals(order,:);
                        end
                    end
                end
                % For display, use the accumulated intervals.
                arr = convertIntervalsToArray(accIntervals);
                
                % Build a title that shows the connection window.
                titleStr = sprintf('Conexiune de la %s până la %s', datestr(conStart, 'HH:MM:SS'), datestr(conStop, 'HH:MM:SS'));
                % x-axis spans the entire simulation time.
                simXLimits = [datenum(app.sc.StartTime), datenum(app.sc.StopTime)];
                
                if ~isempty(cf) && isvalid(cf)
                    fig = cf;
                    clf(fig);
                    fig.Name = 'Connection Intervals';
                else
                    fig = uifigure('Name', 'Connection Intervals', 'Position', [100 100 1000 500]);
                    cf = fig;
                end
                
                gl = uigridlayout(fig, [1, 2]);
                gl.ColumnWidth = {'2x','1x'};
                
                ax = uiaxes(gl);
                ax.Layout.Row = 1;
                ax.Layout.Column = 1;
                hold(ax, 'on');
                fprintf('DEBUG: Number of accumulated intervals to plot: %d\n', size(arr,1));
                if ~isempty(arr)
                    for i = 1:size(arr,1)
                        patch(ax, [datenum(arr(i,1)), datenum(arr(i,2)), datenum(arr(i,2)), datenum(arr(i,1))], ...
                              [0.6, 0.6, 0.9, 0.9], 'red', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
                    end
                end
                hold(ax, 'off');
                xlim(ax, simXLimits);
                datetick(ax, 'x', 'HH:MM:SS', 'keeplimits');
                ylim(ax, [0, 1]);
                ax.YTick = [];
                xlabel(ax, 'Time');
                title(ax, sprintf('%s\nMulti-hop intervals between "%s" and "%s"', ...
                    titleStr, app.GroundStations(idxSource).Name, app.GroundStations(idxTarget).Name));
                
                panelRight = uipanel(gl, 'Title', 'Access Details');
                panelRight.Layout.Row = 1;
                panelRight.Layout.Column = 2;
                txtArea = uitextarea(panelRight, 'Editable', 'off', 'FontName', 'Courier New', 'FontSize', 10, ...
                                     'Position', [10 10 400 450]);
                % Build a formatted details string.
                if istable(accIntervals) && all(ismember({'StartTime','EndTime','Duration'}, accIntervals.Properties.VariableNames))
                    nIntervals = height(accIntervals);
                    lines = strings(nIntervals, 1);
                    for i = 1:nIntervals
                        sTime = datestr(accIntervals.StartTime(i), 'HH:MM:SS');
                        eTime = datestr(accIntervals.EndTime(i), 'HH:MM:SS');
                        dur = accIntervals.Duration(i);
                        lines(i) = sprintf('Interval %d: Start = %s, Stop = %s, Duration = %d', i, sTime, eTime, round(dur));
                    end
                elseif isdatetime(accIntervals) && size(accIntervals,2)==2
                    nIntervals = size(accIntervals,1);
                    lines = strings(nIntervals, 1);
                    for i = 1:nIntervals
                        sTime = datestr(accIntervals(i,1), 'HH:MM:SS');
                        eTime = datestr(accIntervals(i,2), 'HH:MM:SS');
                        lines(i) = sprintf('Interval %d: Start = %s, Stop = %s', i, sTime, eTime);
                    end
                else
                    lines = "No intervals available.";
                end
                
                % Debug: Print each line for inspection.
                for k = 1:length(lines)
                    fprintf('DEBUG: Line %d: %s\n', k, lines(k));
                end
                
                % Convert to a cell array and assign to txtArea.
                txtArea.Value = cellstr(lines);
            end
            
            function arr = convertIntervalsToArray(intv)
                if istable(intv) && all(ismember({'StartTime','EndTime'}, intv.Properties.VariableNames))
                    arr = [intv.StartTime, intv.EndTime];
                elseif isdatetime(intv) && size(intv,2)==2
                    arr = intv;
                else
                    arr = [];
                end
            end
            function nodes = computeMultiHopPath(gsSource, gsTarget, satArray, refTime)
                % COMPUTEMULTIHOPPATH calculates the optimal multi-hop path among ground stations
                % Parameters:
                %   gsSource - Ground station object for the source.
                %   gsTarget - Ground station object for the target.
                %   satArray - Array of Satellite objects available for connection.
                %   refTime  - Reference time (datetime) for geometric calculations.
                % Returns:
                %   nodes - A cell array with the ordered path (source, relay satellites, target).
                % Quality criteria constants:
                MIN_ELEVATION_SOURCE = 30;  % Minimum elevation (degrees) required for source-to-satellite.
                MIN_ELEVATION_TARGET = 30;  % Minimum elevation (degrees) required for satellite-to-target.
                MIN_ELEVATION_RELAY  = -10; % Minimum elevation for inter-satellite links.
                MAX_HOPS = 10;               % Maximum allowed number of hops.
            
                % Calculate elevation angles from the source to each satellite and from each satellite to the target:
                [~, elSourceToSat] = aer(gsSource, satArray, refTime);
                [~, elTargetToSat] = aer(gsTarget, satArray, refTime);
            
                % Identify candidates that satisfy the minimum requirements:
                idxGoodSource = find(elSourceToSat >= MIN_ELEVATION_SOURCE);
                idxGoodTarget = find(elTargetToSat >= MIN_ELEVATION_TARGET);
            
                if isempty(idxGoodSource)  || isempty(idxGoodTarget)
                    nodes = {}; 
                    return
                end
            
                % First, check if any satellite is good for both source and target:
                commonSats = intersect(idxGoodSource, idxGoodTarget);
                if ~isempty(commonSats)
                    % Select the candidate with the highest combined elevation:
                    combinedEl = elSourceToSat(commonSats) + elTargetToSat(commonSats);
                    [~, bestIdx] = max(combinedEl);
                    bestSatIdx = commonSats(bestIdx);
                    nodes = {gsSource, satArray(bestSatIdx), gsTarget};
                    fprintf('Direct path found via satellite %s: elevations %.2f and %.2f.\n', ...
                            satArray(bestSatIdx).Name, elSourceToSat(bestSatIdx), elTargetToSat(bestSatIdx));
                    return;
                end
            
                % If no direct connection exists, start building a multi-hop path:
                nodes = {gsSource};
            
                % Choose the best candidate from the source side based on maximum source elevation:
                [~, bestSourceIdx] = max(elSourceToSat(idxGoodSource));
                firstSatIdx = idxGoodSource(bestSourceIdx);
                nodes{end+1} = satArray(firstSatIdx);
            
                % Check if the first candidate has LOS to the target:
                [~, elCurrentToTarget] = aer(satArray(firstSatIdx), gsTarget, refTime);
                if elCurrentToTarget >= MIN_ELEVATION_TARGET
                    nodes{end+1} = gsTarget;
                    fprintf('Candidate satellite %s directly sees the target.\n', satArray(firstSatIdx).Name);
                    return;
                end
            
                % Set up iteration variables:
                currentSatIdx = firstSatIdx;
                visitedSats = false(1, length(satArray));
                visitedSats(firstSatIdx) = true;
                hopCount = 1;
            
                % Iteratively search for a better relay satellite:
                while hopCount < MAX_HOPS
                    % Get elevation from the current satellite to all candidate satellites:
                    [~, elToSats, ~] = aer(satArray(currentSatIdx), satArray, refTime);
                    % Exclude already visited satellites by setting their elevation to -Inf:
                    elToSats(visitedSats) = -Inf;
                
                    % Consider only candidates that satisfy the relay threshold:
                    candidateIndices = find(elToSats >= MIN_ELEVATION_RELAY);
                    if isempty(candidateIndices)
                        fprintf('No candidate satellites at hop %d meet the relay threshold.\n', hopCount);
                        break;
                    end
                
                    % For each candidate, compute a combined score based on their elevation toward the target and distance:
                    candidateScores = zeros(1, numel(candidateIndices));
                    weight_e = 1.0;      % Weight for elevation (higher is better)
                    weight_r = 0.001;    % Weight for range (lower is better)
                    for j = 1:numel(candidateIndices)
                        candIdx = candidateIndices(j);
                        [~, elCandToTarget, rangeToTarget] = aer(satArray(candIdx), gsTarget, refTime);
                        candidateScores(j) = weight_e * elCandToTarget - weight_r * rangeToTarget;
                    end
                
                    % Select the candidate with the highest score:
                    [~, bestCandidateIdx] = max(candidateScores);
                    nextSatIdx = candidateIndices(bestCandidateIdx);
                
                    % Append the chosen candidate to the path:
                    nodes{end+1} = satArray(nextSatIdx);
                    visitedSats(nextSatIdx) = true;
                    
                    % Immediately check if this candidate qualifies based on target visibility by verifying membership in idxGoodTarget.
                    if ismember(nextSatIdx, idxGoodTarget)
                        nodes{end+1} = gsTarget;
                        fprintf('Target reached immediately because candidate %s is in idxGoodTarget at hop %d.\n', ...
                                satArray(nextSatIdx).Name, hopCount+1);
                        return;
                    end
                
                    % Continue the iterative process:
                    currentSatIdx = nextSatIdx;
                    hopCount = hopCount + 1;
                end
                % --- Final Check After Loop ---
                [~, elLastToTarget] = aer(satArray(currentSatIdx), gsTarget, refTime);
                if elLastToTarget >= MIN_ELEVATION_TARGET
                    nodes{end+1} = gsTarget;
                    fprintf('Target reached in final check at hop %d.\n', hopCount);
                else
                    fprintf('Incomplete path: target not reached after %d hops.\n', hopCount);
                    % --- debug: afişăm lista de noduri încercate ---
                    fprintf('Nodes visited: ');
                    for i = 1:numel(nodes)
                        % fiecare node are proprietatea Name
                        fprintf('%s', nodes{i}.Name);
                        if i< numel(nodes)
                            fprintf(' -> ');
                        end
                    end
                    fprintf('\n');
                    ac = access(nodes{:});
                    nodes = {};  % Optionally, return an empty path if completeness is required.
                end
            end

        end

        % Button pushed function: ActualizaretimpButton
        function ActualizaretimpButtonPushed(app, event)
            % Preia stopTime din obiectul satellitescenario SC
            stopTime = app.sc.StopTime;  % Presupunând că acesta are o zonă orară setată, de ex. 'UTC'
            
            % Preia ora introdusă din EditField_2 (format "HH:mm:ss") și setează data
            try
                tempTime = datetime(app.EditField_2.Value, 'InputFormat', 'HH:mm:ss', 'Format', 'HH:mm:ss');
                % Aliniază data cu data de start a simulării
                newTime = dateshift(app.sc.StartTime, 'start', 'day') + timeofday(tempTime);
            catch
                uialert(app.UIFigure, 'Introduceți ora în formatul HH:mm:ss!', 'Eroare');
                return;
            end
                    
            % Verifică dacă timpul introdus depășește timpul total de simulare
            if newTime > stopTime
                uialert(app.UIFigure, 'Timpul introdus depășește timpul total de simulare!', 'Eroare');
                return;
            end
                    
            % Actualizează variabila de referință
            app.UserSelectedTime = newTime;
                    
            % Actualizează parametrii stației folosind noul timp
            updateStationParameters(app);
        end

        % Button pushed function: AcceslasatelitButton
        function AcceslasatelitButtonPushed(app, event)
                if isempty(app.sc) || ~isvalid(app.sc)
                    uialert(app.UIFigure, 'Scenariul nu este inițializat.', 'Eroare');
                    return;
                end
                % Verifică selecțiile pentru stație și satelit
                gsIdx = app.ControlStaieDropDown.Value;
                if isempty(gsIdx) || gsIdx > length(app.GroundStations)
                    uialert(app.UIFigure, 'Selectați o stație de sol validă.', 'Eroare');
                    return;
                end
                auto=false;
                satIndices = app.ControlSateliiDropDown.Value;
                if isempty(satIndices)
                    uialert(app.UIFigure, 'Selectați un satelit valid.', 'Eroare');
                    return;
                end
                idxConst = satIndices{1};
                idxSat   = satIndices{2};
                if idxConst > length(app.Constelatii) || idxSat > length(app.Constelatii(idxConst).Sateliti)
                    uialert(app.UIFigure, 'Selectați un satelit valid.', 'Eroare');
                    return;
                end
            
                %Obține obiectele stației și satelitului
                gs = app.GroundStations(gsIdx);
                satStruct = app.Constelatii(idxConst).Sateliti(idxSat);
                satObj = satStruct.Object;
                satName = satStruct.Nume;
                
               
                % Obține sau calculează intervalele de acces
                existingIdx = [];
                if isfield(gs, 'AccessLog') && ~isempty(gs.AccessLog.Satellite)
                    for k = 1:length(gs.AccessLog.Satellite)
                        if strcmp(gs.AccessLog.Satellite{k}, satName)
                            existingIdx = k;
                            break;
                        end
                    end
                end
            
                if ~isempty(existingIdx)
                    intervals = gs.AccessLog.AccessIntervals{existingIdx};
                else
                    try
                         % Dacă AutoSimulate este false
                        if ~app.sc.AutoSimulate
                            app.sc.AutoSimulate = true;
                            auto=true;
                        end
                        ac = access(gs.Object, satObj);
                        intervals = accessIntervals(ac);
                    catch ME
                        uialert(app.UIFigure, ['Eroare la calcularea accesului: ' ME.message], 'Eroare');
                        return;
                    end
            
                    if isempty(ac)
                        uialert(app.UIFigure, 'Nu se poate accesa satelitul de la stația de sol respectivă.', 'Eroare');
                        return;
                    end
            
                    % Salvează accesul în AccessLog
                    if ~isfield(gs, 'AccessLog') || isempty(gs.AccessLog)
                        gs.AccessLog.Satellite = {satName};
                        gs.AccessLog.AccessIntervals = {intervals};
                        gs.AccessLog.AccessObject = {ac};
                    else
                        gs.AccessLog.Satellite{end+1} = satName;
                        gs.AccessLog.AccessIntervals{end+1} = intervals;
                        gs.AccessLog.AccessObject{end+1} = ac;
                    end
                    app.GroundStations(gsIdx) = gs;  % Actualizează structura în aplicație
                end
                % Afișează fereastra de acces cu intervalele calculate
                showAccessUsingIntervals(intervals, gs, satName);

                 % 1) Calculează și reshape-uiește vectorii
                    [delay,   tLatency]    = latency(   satObj, gs.Object);
                    [fShift,  tDoppler, dopInfo] = dopplershift(satObj, gs.Object, 'Frequency',5e9);
                
                    % forțează coloană și convertește datetime → datenum
                   tNumLat    = datenum(tLatency(:));
                    latency_ms = delay(:) * 1000;
                    tNumDop    = datenum(tDoppler(:));
                    shift_khz  = fShift(:) / 1e3;
                    dop_rate   = dopInfo.DopplerRate(:);
                
                    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                    % Figură unică cu 3 panouri
                    figAll = uifigure('Name','Analiză latență și Doppler','Position',[200 200 900 700]);
                    tlo    = tiledlayout(figAll, 3, 1, 'TileSpacing','compact','Padding','compact');
                
                    % –– Panoul 1: Latență
                    ax1 = nexttile(tlo,1);
                    plot(ax1, tNumLat, latency_ms, 'LineWidth',1.5);
                    datetick(ax1,'x','HH:MM:SS','keeplimits');
                    ylabel(ax1, 'Latență (ms)');
                    title(ax1,   'Latența transmisiei');
                
                    % –– Panoul 2: Doppler shift
                    ax2 = nexttile(tlo,2);
                    plot(ax2, tNumDop, shift_khz, 'LineWidth',1.5);
                    datetick(ax2,'x','HH:MM:SS','keeplimits');
                    ylabel(ax2, 'Shift (kHz)');
                    title(ax2,   'Deplasare Doppler');
                
                    % –– Panoul 3: Doppler rate (aliniat la cele N−1 mostre)
                    nRate = numel(dop_rate);
                    tRate = tNumDop(1:nRate);  % taie ultimul element
                    ax3   = nexttile(tlo,3);
                    plot(ax3, tRate, dop_rate, '--', 'LineWidth',1.5);
                    datetick(ax3,'x','HH:MM:SS','keeplimits');
                    xlabel(ax3,'Timp');
                    ylabel(ax3,'Rată (Hz/s)');
                    title(ax3,   'Rata de schimbare a Doppler-ului');
                if auto
                    app.sc.AutoSimulate = false;
                end

                % Funcția pentru afișarea intervalelor și graficului
                function showAccessUsingIntervals(intervals, gs, satName)
                    % Dacă intervals este un tabel, îl convertim într-un array Nx2 de datetime.
                    if istable(intervals)
                        if all(ismember({'StartTime','EndTime'}, intervals.Properties.VariableNames))
                            intervals = [intervals.StartTime, intervals.EndTime];
                        else
                            error('Tabelul intervals trebuie să conțină coloanele "StartTime" și "EndTime".');
                        end
                    end
                    % Creează fereastra cu titlul personalizat
                    figTitle = sprintf('Acces la Satelitul "%s" de la Stația "%s"', satName, gs.Name);
                    fig = uifigure('Name', figTitle, 'Position', [100 100 800 400]);
                    gl = uigridlayout(fig, [1, 2]);
                    gl.ColumnWidth = {'1x','1x'};
            
                    % Partea stângă: Timeline cu patch
                    ax = uiaxes(gl);
                    ax.Layout.Row = 1;
                    ax.Layout.Column = 1;
                    hold(ax, 'on');
                    for i = 1:size(intervals,1)
                        startNum = datenum(intervals(i,1));
                        endNum   = datenum(intervals(i,2));
                        patch(ax, [startNum, endNum, endNum, startNum], [0, 0, 1, 1], 'blue', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
                    end
                    hold(ax, 'off');
                    startScenario = datenum(app.sc.StartTime);
                    stopScenario  = datenum(app.sc.StopTime);
                    xlim(ax, [startScenario, stopScenario]);
                    datetick(ax, 'x', 'HH:MM:SS','keeplimits');
                    ylim(ax, [0 1]);
                    ax.YTick = [];
                    xlabel(ax, 'Timp');
                    title(ax, sprintf('Acces între %s și %s', gs.Name, satName));
            
                    % Partea dreaptă: Listă intervale + disponibilitate
                    panelRight = uipanel(gl, 'Title', 'Detalii Acces');
                    panelRight.Layout.Row = 1;
                    panelRight.Layout.Column = 2;
                    txtArea = uitextarea(panelRight, 'Editable', 'off', ...
                        'FontName', 'Courier New', 'FontSize', 10, 'Position', [10 10 360 340]);
            
                    accessStr = "";
                    for i = 1:size(intervals,1)
                        startStr = datestr(intervals(i,1), 'HH:MM:SS');
                        stopStr  = datestr(intervals(i,2), 'HH:MM:SS');
                        accessStr = accessStr + sprintf("Acces %d: Start = %s, Stop = %s\n", i, startStr, stopStr);
                    end
            
                    totalAccessDuration = sum(intervals(:,2) - intervals(:,1));  % durata în zile
                    totalAccessSec = seconds(totalAccessDuration);
                    scenarioDuration = seconds(app.sc.StopTime - app.sc.StartTime);
                    coveragePercent = (totalAccessSec / scenarioDuration) * 100;
            
                    % Convertim duratele la format HH:MM:SS (datestr primește valori în zile)
                    coverageStr = datestr(totalAccessSec/86400, 'HH:MM:SS');
                    scenarioStr = datestr(scenarioDuration/86400, 'HH:MM:SS');
            
                    coverageInfo = sprintf(['\nTimp total de acoperire: %s\n' ...
                                            'Durata scenariu:         %s\n' ...
                                            'Disponibilitate:         %.2f%%\n'], ...
                                            coverageStr, scenarioStr, coveragePercent);
            
                    txtArea.Value = splitlines(accessStr + coverageInfo);
                end

        end

        % Callback function
        function AntenrecepieDropDownValueChanged(app, event)
 
        end

        % Button pushed function: RestartButton
        function RestartButtonPushed(app, event)
            % Verifică dacă scenariul a fost inițializat și este valid
            if ~app.isScenarioInitialized() || ~isvalid(app.sc)
                 uialert(app.UIFigure, 'Scenariul nu este inițializat. Apăsați butonul "Start" pentru a inițializa simularea.', 'Eroare');
                 return;
            end
            app.sc.AutoSimulate = false;
            % Resetează scenariul (refresh)
            restart(app.sc);
            app.sc.AutoSimulate = true;
            hide(app.sc.Satellites.Accesses);
            hide(app.sc.GroundStations.Accesses);            
            % Actualizează statusul aplicației
            updateStatus(app, 'Scenariul de simulare a fost reîmprospătat.');
        end

        % Button pushed function: nchidescenariuButton
        function nchidescenariuButtonPushed(app, event)
            % Solicită confirmarea utilizatorului
            selection = uiconfirm(app.UIFigure, ...
                'Sigur doriți să închideți și să ștergeți scenariul? Această acțiune va elimina toate datele asociate.', ...
                'Confirmare Închidere Scenariu', ...
                'Options', {'Da','Nu'}, ...
                'DefaultOption', 'Nu');
            if strcmp(selection, 'Nu')
                return;
            end
            % Închide toate ferestrele de vizualizare asociate scenariului
            if ~isempty(app.sc) && isvalid(app.sc)
                if isfield(app.sc, 'Viewers') && ~isempty(app.sc.Viewers)
                    for k = 1:length(app.sc.Viewers)
                        viewerHandle = app.sc.Viewers(k);
                        close(viewerHandle);
                        
                    end
                    app.sc.Viewers = [];
                end
            end
        
            % Închide și fereastra salvată în variabila v, dacă există
            if ~isempty(app.v)
                delete(app.v);
            end
        
            % Șterge obiectul scenariului
            app.sc = [];
        
            % Resetează structurile ce stochează datele despre sateliți și stații de sol
            app.Constelatii = struct( ...
                'Nume', {}, 'AltitudineMedie', {}, 'NumarSateliti', {}, 'IsLarge', {}, 'IsVisible', {}, ...
                'Sateliti', struct( ...
                    'Nume', {}, 'Object', {}, 'Altitudine', {}, 'Inclinatie', {}, 'OrbitType', {}, ...
                    'GroundTrack', {}, 'IsVisible', {}, 'GroundTrackVisible', {}, ...
                    'VisibilityConstraints', struct('MinElevation', 10, 'MaxRange', {}), ...
                    'TxGimbal', {}, 'RxGimbal', {}, ...
                    'Emisie', struct('TxFeederLoss', {}, 'OtherTxLosses', {}, 'TxHPAPower', {}, 'TxHPAOBO', {}, 'TxAntennaGain', {}), ...
                    'Receptie', struct('InterferenceLoss', {}, 'RxGByT', {}, 'RxFeederLoss', {}, 'OtherRxLosses', {}), ...
                    'OnBoardCamera', {}, 'FlagCamera', {} ...
                ), ...
                'ObiectSateliti', {}, 'Receiver', {}, 'Emitter', {} ...
            );
            
            app.GroundStations = struct( ...
                'Name', {}, 'Object', {}, 'IsVisible', {}, 'Latitude', {}, 'Longitude', {}, ...
                'AntennaSelection', {}, ...
                'Links', struct( ...
                    'Uplink', struct('FrequencyGHz', {}, 'BandwidthMHz', {}, 'BitRateMbps', {}, 'RequiredEbByNo_dB', {}, 'PolarizationMismatch_deg', {}, 'ImplementationLoss', {}, 'AntennaMispointingLoss', {}, 'RadomeLoss', {}), ...
                    'Downlink', struct('FrequencyGHz', {}, 'BandwidthMHz', {}, 'BitRateMbps', {}, 'RequiredEbByNo_dB', {}, 'PolarizationMismatch_deg', {}, 'ImplementationLoss', {}, 'AntennaMispointingLoss', {}, 'RadomeLoss', {}) ...
                ), ...
                'VisibilityConstraints', struct('MinElevation', 10, 'MaxRange', []), ...
                'AccessLog', struct('Satellite', {{}}, 'AccessIntervals', {{}}, 'AccessObject', {{}}), ...
                'Emisie', struct('Altitude', {}, 'TxFeederLoss', {}, 'OtherTxLosses', {}, 'TxHPAPower', {}, 'TxHPAOBO', {}, 'TxAntennaGain', {}), ...
                'Receptie', struct('Altitude', {}, 'InterferenceLoss', {}, 'RxGByT', {}, 'RxFeederLoss', {}, 'OtherRxLosses', {}), ...
                'Meteo', struct('Temperature_C', {}, 'Humidity_proc', {}, 'Pressure_hPa', {}), ...
                'Receiver', {}, 'Emitter', {} ...
            );

            % Resetează contorul de sateliți
            app.nrsat = 0;
            % Golește dropdown-urile care afișează datele despre constelații, sateliți și stații de sol
            app.ControlConstelaieDropDown.Items = {};
            app.ControlConstelaieDropDown.ItemsData = {};
           
            app.ControlSateliiDropDown.Items = {};
            app.ControlSateliiDropDown.ItemsData = {};
            
            app.ControlStaieDropDown.Items = {};
            app.ControlStaieDropDown.ItemsData = {};
            
            app.StaiesursDropDown.Items = {};
            app.StaiesursDropDown.ItemsData = {};
            
            app.StaiedestinaieDropDown.Items = {};
            app.StaiedestinaieDropDown.ItemsData = {};
            app.istoricFisiere = {};
            app.AfieazConstelaieCheckBox.Value=false;
            app.AfieazsatelitCheckBox.Value=false;
            app.AfieazCheckBox_2.Value=false;
            app.UrmalasolCheckBox.Value=false;
            app.ParametriiSatelitTextArea.Value='Nimic de afisat';
            app.ParametriiStaieTextArea.Value='Nimic de afisat';
            % Actualizează statusul în interfață
            updateStatus(app, 'Scenariul și toate ferestrele de vizualizare au fost șterse. Puteți reinițiliza un scenariu.');
            app.satelitiobj = []; 
        end

        % Value changed function: FotografieazCheckBox
        function FotografieazCheckBoxValueChanged(app, event)
           % Verifică dacă fereastra de vizualizare este activă
            if ~app.isViewerOpen()
                uialert(app.UIFigure, 'Fereastra de vizualizare nu este pornită. Porniți vizualizarea înainte de a face modificări.', 'Eroare');
                app.FotografieazCheckBox.Value = false;
                return;
            end
        
            isChecked = app.FotografieazCheckBox.Value;
            
            % Preia satelitul selectat din dropdown-ul de sateliți
            selectedIndex = app.ControlSateliiDropDown.Value;
            if isempty(selectedIndex)
                uialert(app.UIFigure, 'Nu a fost selectat niciun satelit.', 'Eroare');
                app.FotografieazCheckBox.Value = false;
                return;
            end
        
            idxConst = selectedIndex{1};
            idxSat   = selectedIndex{2};
            if idxConst > length(app.Constelatii) || idxSat > length(app.Constelatii(idxConst).Sateliti)
                uialert(app.UIFigure, 'Index invalid pentru constelație sau satelit.', 'Eroare');
                app.FotografieazCheckBox.Value = false;
                return;
            end
        
            % Obține structura satelitului selectat
            sat = app.Constelatii(idxConst).Sateliti(idxSat);
            
            if isChecked
                % Activează flag-ul camerei
                sat.FlagCamera = true;
                % Dacă obiectul camerei (conical sensor) nu există sau nu este valid, se creează unul
                if isempty(sat.OnBoardCamera)
                    % Se creează sensor folosind parametrul 'MaxViewAngle'
                    sat.OnBoardCamera = conicalSensor(sat.Object, 'MaxViewAngle', 30);
                    % Dacă există un ground station selectat si este vizibil, orientează sensorul către acesta
                    if ~isempty(app.ControlStaieDropDown.Value)
                        gsIdx = app.ControlStaieDropDown.Value; 
                         if gsIdx <= length(app.GroundStations)
                            if app.GroundStations(gsIdx).IsVisible
                                pointAt(sat.Object, app.GroundStations(gsIdx).Object);
                            end
                         end
                    end
                    fieldOfView(sat.OnBoardCamera);
                else
                    
                    % Actualizează orientarea dacă este selectat un ground station
                    if ~isempty(app.ControlStaieDropDown.Value) && app.ControlStaieDropDown.Value <= length(app.GroundStations)
                        gsIdx = app.ControlStaieDropDown.Value; 
                        if gsIdx <= length(app.GroundStations)
                            if app.GroundStations(gsIdx).IsVisible
                                pointAt(sat.Object, app.GroundStations(gsIdx).Object);
                            end
                         end
                    end
                    show(sat.OnBoardCamera.fieldOfView);
                end
            else
                % Dezactivează flag-ul camerei
                sat.FlagCamera = false;
                % Dacă sensorul există, îl ascunde
                if ~isempty(sat.OnBoardCamera)
                    hide(sat.OnBoardCamera.fieldOfView);
                end
            end
        
            % Actualizează structura satelitului în cadrul constelației
            app.Constelatii(idxConst).Sateliti(idxSat) = sat;
        end

        % Callback function
        function EmisieButton_2Pushed(app, event)
            
        end

        % Callback function
        function LinkButtonPushed(app, event)
            
        end

        % Callback function
        function RecepieButton_2Pushed(app, event)

        end

        % Button pushed function: AscundeAccesButton
        function AscundeAccesButtonPushed(app, event)
            % Verifică selecțiile pentru stație și satelit
            gsIdx = app.ControlStaieDropDown.Value;
            if isempty(gsIdx) || gsIdx > length(app.GroundStations)
                uialert(app.UIFigure, 'Selectați o stație de sol validă.', 'Eroare');
                return;
            end
        
            satIndices = app.ControlSateliiDropDown.Value;
            if isempty(satIndices)
                uialert(app.UIFigure, 'Selectați un satelit valid.', 'Eroare');
                return;
            end
        
            idxConst = satIndices{1};
            idxSat   = satIndices{2};
            if idxConst > length(app.Constelatii) || idxSat > length(app.Constelatii(idxConst).Sateliti)
                uialert(app.UIFigure, 'Selectați un satelit valid.', 'Eroare');
                return;
            end
            
            % Obține obiectele stației și satelitului
            gs = app.GroundStations(gsIdx);
            satStruct = app.Constelatii(idxConst).Sateliti(idxSat);
            satName = satStruct.Nume;
            % Verifică dacă există acces înregistrat pentru satelit în AccessLog
            existingIdx = [];
            if isfield(gs, 'AccessLog') && ~isempty(gs.AccessLog) && isfield(gs.AccessLog, 'Satellite')
                for k = 1:length(gs.AccessLog.Satellite)
                    if strcmp(gs.AccessLog.Satellite{k}, satName)
                        existingIdx = k;
                        break;
                    end
                end
            end
            if isempty(existingIdx)
                uialert(app.UIFigure, 'Nu există acces înregistrat între satelit și stația selectată.', 'Informație');
                return;
            end

            hide(gs.AccessLog.AccessObject{existingIdx});

            gs.AccessLog.Satellite(existingIdx)       = [];
            gs.AccessLog.AccessIntervals(existingIdx) = [];
            gs.AccessLog.AccessObject(existingIdx)    = [];

            if isempty(gs.AccessLog.Satellite)
                gs.AccessLog = struct( ...
                    'Satellite',       {{}}, ...
                    'AccessIntervals', {{}}, ...
                    'AccessObject',    {{}} );
            end

            app.GroundStations(gsIdx) = gs;
        end

        % Button pushed function: InterferenButton
        function InterferenButtonPushed(app, event)
            % 1) Validate scenario
            if isempty(app.sc) || ~isvalid(app.sc)
                uialert(app.UIFigure, 'Scenariul nu este inițializat.', 'Eroare');
                return;
            end
        
            % 2) Validate ground station selection
            gsIdx = app.ControlStaieDropDown.Value;
            if gsIdx < 1 || gsIdx > numel(app.GroundStations)
                uialert(app.UIFigure, 'Selectați o stație de sol validă.', 'Eroare');
                return;
            end
            gs = app.GroundStations(gsIdx);

            % 3) Validate satellite selection
            satSel = app.ControlSateliiDropDown.Value;
            if isempty(satSel) || numel(satSel) < 2
                uialert(app.UIFigure, 'Selectați un satelit valid.', 'Eroare');
                return;
            end
            constIdx = satSel{1};
            satIdx   = satSel{2};
            if constIdx < 1 || constIdx > numel(app.Constelatii) || ...
               satIdx   < 1 || satIdx   > numel(app.Constelatii(constIdx).Sateliti)
                uialert(app.UIFigure, 'Selectați un satelit valid.', 'Eroare');
                return;
            end
            satObj = app.Constelatii(constIdx).Sateliti(satIdx).Object;
            satName = app.Constelatii(constIdx).Sateliti(satIdx).Nume;

            if ~app.sc.AutoSimulate
                app.sc.AutoSimulate = true;
            end
                
            try
                ac = access(gs.Object, satObj);
                intervals = accessIntervals(ac);
                hide(ac);
            catch ME
                uialert(app.UIFigure, ['Eroare la calcularea accesului: ' ME.message], 'Eroare');
                return;
            end
            
            % Dacă nu există acces deloc
            if isempty(intervals)
                uialert( app.UIFigure, ...
                    sprintf('Nu se poate accesa satelitul "%s" de la stația de sol "%s".', ...
                            satName, gs.Name), ...
                    'Eroare' );

                return;
            end

            % 4) Construim lista satelitilor interferenta
            isSame = [app.satelitiobj.ID] == satObj.ID; 
            % Păstrează toate elementele care NU sunt satObj
            otherSats = app.satelitiobj(~isSame);

            if isempty(otherSats)
                uialert(app.UIFigure, ...
                    'Nu mai există alți sateliți în simulare.', ...
                    'Atenție','Icon','warning');
                return;
            end
        
            % 5) Compute access for each other satellite
            accessObjs = access(otherSats, gs.Object);
            accessIDs = zeros(1, numel(accessObjs));
            % Extrage ID-urile din accessObjs care au Sequence nenul (adică acces real)
            for i = 1:numel(accessObjs)
                if ~isempty(accessObjs(i).Sequence)
                    accessIDs(end+1) = accessObjs(i).Sequence(1);  % sau doar Sequence dacă e scalar
                end
            end
            % Găsim care sateliți din otherSats au ID-ul în accessIDs
            isInterferer = ismember(otherSats.ID, accessIDs);
            
            % Filtrăm doar satelitii de interes
            interferers = otherSats(isInterferer);

            % Dacă nu există interferenți, avertizăm
            if isempty(interferers)
                uialert(app.UIFigure, ...
                    'Niciun satelit nu are acces valid la stația de sol.', ...
                    'Info', 'Icon', 'warning');
                return;
            end

            % Variante disponibile de antene
            antennaOptions = {'Gaussian Antenna', 'Parabolic Reflector'};
            
            % Fereastră de selecție tip dropdown
            [antennaChoiceIndex, tf] = listdlg( ...
                'PromptString', 'Selectați tipul antenei pentru stația de sol:', ...
                'SelectionMode', 'single', ...
                'ListString', antennaOptions, ...
                'Name', 'Selectare Antenă', ...
                'ListSize', [200, 100]);
            
            % Verificare dacă utilizatorul a ales ceva sau a închis fereastra
            if ~tf
                uialert(app.UIFigure, 'Nu ați selectat un tip de antenă.', 'Atenție');
                return;
            end
          
            % --- Prompt pentru puteri și parametri adiționali ---
            prompt = { ...
                'Introduceți puterea satelitului principal (dBW):', ...
                'Introduceți puterea sateliților interferenți (dBW):', ...
                'Introduceți bit rate-ul satelitului principal (bps):', ...
                'Introduceți Required Eb/No al stației de sol (dB):'};
            
            dlgtitle = 'Configurare parametri sateliți și stație de sol';
            dims = [1 50];
            definput = {'11', '8', '1e6', '7'};  % Exemplu: 1 Mbps bit rate și 7 dB required Eb/No
            
            answer = inputdlg(prompt, dlgtitle, dims, definput);
            
            % --- Verificare dacă utilizatorul a apăsat Cancel ---
            if isempty(answer)
                uialert(app.UIFigure, 'Configurarea a fost anulată.', 'Atenție');
                return;
            end
            % Validare și conversie fiecare câmp
            powerSatellite_dBW = str2double(answer{1});
            if isnan(powerSatellite_dBW)
                uialert(app.UIFigure, 'Introduceți un număr valid pentru puterea satelitului principal.', 'Eroare');
                return;
            end
            
            powerInterferers_dBW = str2double(answer{2});
            if isnan(powerInterferers_dBW)
                uialert(app.UIFigure, 'Introduceți un număr valid pentru puterea sateliților interferenți.', 'Eroare');
                return;
            end
            
            bitRateSatellite = str2double(answer{3});
            if isnan(bitRateSatellite) || bitRateSatellite <= 0
                uialert(app.UIFigure, 'Introduceți un bit rate pozitiv valid pentru satelitul principal.', 'Eroare');
                return;
            end
            
            requiredEbNoGS = str2double(answer{4});
            if isnan(requiredEbNoGS)
                uialert(app.UIFigure, 'Introduceți un număr valid pentru Required Eb/No al stației de sol.', 'Eroare');
                return;
            end

            % Selectăm tipul antenei în funcție de alegerea utilizatorului
            groundStationAntennaType = antennaOptions{antennaChoiceIndex};
            
            % Frecvența transmisiei de la satelitul principal
            txMEOFreq = 3e9;  % 3 GHz
            interferenceFreq = 2.99e9;
            % Creează Transmitter pentru satelitul principal
            txs = transmitter(satObj, ...
                              Frequency = txMEOFreq, ...
                              Power = powerSatellite_dBW,...
                              BitRate = bitRateSatellite);    
            
            % Setează antenă gaussiană pentru satelitul principal
            gaussianAntenna(txs, DishDiameter=1);  % 1 metru
            
            % Creează Transmitere pentru sateliții interferenți
            txIfc = transmitter(interferers, ...
                                Frequency = interferenceFreq, ...
                                Power = powerInterferers_dBW * ones(1, numel(interferers))); 
            
            % Setează antene gaussiane pentru toți sateliții interferenți
            gaussianAntenna(txIfc, DishDiameter=1);  % 1 metru pentru fiecare interferent
            
            % Creează Gimbal pentru stația de sol
            gim = gimbal(gs.Object, ...
                         MountingLocation = [0;0;-5], ...
                         MountingAngles = [0;180;0]);
            
            % Direcționează Gimbal-ul spre satelitul principal
            pointAt(gim, satObj);
            
            % Creează Receiver pe Gimbal-ul stației de sol, în funcție de antena aleasă
            switch groundStationAntennaType
                case 'Gaussian Antenna'
                    % Antenă Gaussiană
                    rxGs = receiver(gim, ...
                                    MountingLocation = [0;0;1],...
                                    RequiredEbNo = requiredEbNoGS);
                    gaussianAntenna(rxGs, DishDiameter = 2);  % 0.8 m diametru
                    
                case 'Parabolic Reflector'
                    % Antenă Parabolică proiectată la 3 GHz
                    ant = design(reflectorParabolic, txMEOFreq);  % 3 GHz
                    rxGs = receiver(gim, ...
                                    Antenna = ant, ...
                                    MountingLocation = [0;0;1]);
            end
            
            
            pointAt([satObj, interferers],gs.Object);
            % 11) Creare downlink dorit (MEO → GS)
            downlink = link(txs, rxGs);
            
            % 12) Creare linkuri de interferență (LEO → GS)
            lnkInterference = link(txIfc, rxGs);

            % 13) Vizualizează pattern-ul antenei transmitătorului MEO
            pattern(txs, ...
                Size = 1e6);        % În metri
            
            % 14) Vizualizează pattern-ul antenei receptorului GS
            pattern(rxGs,txMEOFreq, ...
                Size = 1e6);        % În metri

            % 14) Link status şi puteri la intrarea receptorului
            [downlinkStatus, t] = linkStatus(downlink);
            [~, downlinkPowerRxInput]    = sigstrength(downlink);      % dBW
            [~, interferencePowerRxInput] = sigstrength(lnkInterference);% dBW
            
            % 15) Convertire în W şi sumare
            interferencePowerW       = 10.^(interferencePowerRxInput/10); 
            interferencePowerSumW    = sum(interferencePowerW);
            
            % 16) Setare benzi
            txBandwidth           = 30e6;   % Hz
            interferenceBandwidth = 20e6;   % Hz
            
            % 17) Factor de suprapunere
            overlapFactor = getOverlapFactor(txMEOFreq, txBandwidth, ...
                                             interferenceFreq, interferenceBandwidth);
            
            % 18) Interferenţa efectivă
            interfPowerActualW = interferencePowerSumW * overlapFactor;  % W
            
            % 19) Zgomot termic
            T          = HelperGetNoiseTemperature(txMEOFreq, gs);      % K
            kb         = physconst("Boltzmann");                         
            thermalW   = kb * T * txBandwidth;                            % W
            
            % 20) Zgomot + interferenţă la receptor
            noisePlusIfcW      = thermalW + interfPowerActualW;
            noisePlusIfc_dBW   = 10*log10(noisePlusIfcW);                  % dBW
            
            % 21) Pierderi de sistem
            rxGsLoss = rxGs.SystemLoss - rxGs.PreReceiverLoss;             % dB
            
            % 22) C/(N0+I0) la intrarea demodulatorului
            CNo_I0 = downlinkPowerRxInput ...
                   - noisePlusIfc_dBW ...
                   + 10*log10(txBandwidth) ...
                   - rxGsLoss;                                            % dB·Hz
            
            % 23) Eb/No + I0
            bitRate               = txs.BitRate;                       % bps
            ebNo_I0               = CNo_I0 ...
                                 - 10*log10(bitRate) ...
                                 - 60;                                    % dB
            
            % 24) Margine şi stare link
            marginWithIfc             = ebNo_I0 - rxGs.RequiredEbNo;      
            downlinkStatusWithIfc     = (marginWithIfc >= 0);              % true/false
            
            % 25) Calcul CNR fără interferenţă
            noise_dBW = 10*log10(thermalW);  % convertim zgomotul termic în dBW
            CNo       = downlinkPowerRxInput ...
                      - noise_dBW ...
                      + 10*log10(txBandwidth) ...
                      - rxGsLoss;            % C/(N0) în dB·Hz
            cByN      = CNo - 10*log10(txBandwidth);  % CNR în dB
        
            % 26) Margine fără interferenţă (din eb/No ideal)
            ebnoDownlink = CNo ...
                      - 10*log10(bitRate) ...
                      - 60;                 % dB
            %ebnoDownlink              = ebno(downlink);           % Eb/No fără interferenţă (dB)

            marginWithoutInterference = ebnoDownlink ...
                                     - rxGs.RequiredEbNo;        % marja (dB)
        
            % 27) Calcul CNIR = C/(N0+I0) în dB
            cByNPlusI = CNo_I0 - 10*log10(txBandwidth);            % CNIR în dB
            
            % Vectori de timp unde link-ul cu interferență cade
            linkDropIdx = find(marginWithIfc < 0);

            % --- Creăm fereastra principală
            fig = uifigure( ...
                'Name', 'Analiza Interferențelor', ...
                'WindowState', 'maximized' ...
            );
            
            % --- Grup de taburi pe toată fereastra
            tg = uitabgroup(fig, ...
                'Units','normalized', ...
                'Position',[0 0 1 1] ...
            );
            
            % ---------------------------------------------------------------------------
            % TAB 1 - Link Status
            tab1 = uitab(tg, 'Title', 'Link Status');
            grid1 = uigridlayout(tab1, [2,1], ...
                'RowHeight', {'1x',50}, ...
                'Padding', [10 10 10 10]);
            
            ax1 = uiaxes(grid1);
            ax1.Layout.Row = 1;
            ax1.Layout.Column = 1;
            plot(ax1, t, downlinkStatusWithIfc, '-r', ...
                     t, downlinkStatus, '--g', 'LineWidth', 2);
            legend(ax1, 'With interference','Without interference','Location','best');
            xlabel(ax1, 'Time');
            ylabel(ax1, 'Closure Status');
            title(ax1, 'Link Closure Status vs. Time');
            ylim(ax1, [-0.1 1.1]);
            grid(ax1, 'on');
            grid(ax1, 'minor');
            
            btn1 = uibutton(grid1, ...
                'Text', 'Salvează Graficul', ...
                'ButtonPushedFcn', @(btn,event) saveCurrentAxes(ax1, 'LinkStatus.png'));
            btn1.Layout.Row = 2;
            btn1.Layout.Column = 1;
            
            % ---------------------------------------------------------------------------
            % TAB 2 - CNR și CNIR
            tab2 = uitab(tg, 'Title', 'CNR și CNIR');
            grid2 = uigridlayout(tab2, [2,1], ...
                'RowHeight', {'1x',50}, ...
                'Padding', [10 10 10 10]);
            
            ax2 = uiaxes(grid2);
            ax2.Layout.Row = 1;
            ax2.Layout.Column = 1;
            plot(ax2, t, cByNPlusI, '-r', ...
                     t, cByN, '--g', 'LineWidth', 2);
            legend(ax2, 'CNIR','CNR','Location','south');
            xlabel(ax2, 'Time');
            ylabel(ax2, 'CNR / CNIR (dB)');
            title(ax2, ['CNR and CNIR vs. Time for ' groundStationAntennaType]);
            grid(ax2, 'on');
            grid(ax2, 'minor');
            ylim(ax2, 'auto');
            
            btn2 = uibutton(grid2, ...
                'Text', 'Salvează Graficul', ...
                'ButtonPushedFcn', @(btn,event) saveCurrentAxes(ax2, 'CNR_CNIR.png'));
            btn2.Layout.Row = 2;
            btn2.Layout.Column = 1;
            
            % ---------------------------------------------------------------------------
            % TAB 3 - Link Margin
            tab3 = uitab(tg, 'Title', 'Link Margin');
            grid3 = uigridlayout(tab3, [2,1], ...
                'RowHeight', {'1x',50}, ...
                'Padding', [10 10 10 10]);
            
            ax3 = uiaxes(grid3);
            ax3.Layout.Row = 1;
            ax3.Layout.Column = 1;
            plot(ax3, t, marginWithIfc, '-r', ...
                     t, marginWithoutInterference, '--g', 'LineWidth', 2);
            legend(ax3, 'With interference','Without interference','Location','south');
            xlabel(ax3, 'Time');
            ylabel(ax3, 'Margin (dB)');
            title(ax3, ['Link Margin vs. Time for ' groundStationAntennaType]);
            grid(ax3, 'on');
            grid(ax3, 'minor');
            ylim(ax3, 'auto');
            hold(ax3, 'on');
            plot(ax3, t(linkDropIdx), marginWithIfc(linkDropIdx), 'rx', 'MarkerSize',8, 'LineWidth',2);
            hold(ax3, 'off');
            
            btn3 = uibutton(grid3, ...
                'Text', 'Salvează Graficul', ...
                'ButtonPushedFcn', @(btn,event) saveCurrentAxes(ax3, 'LinkMargin.png'));
            btn3.Layout.Row = 2;
            btn3.Layout.Column = 1;
            
            % ---------------------------------------------------------------------------
            % TAB 4 - Eb/No with Interference
            tab4 = uitab(tg, 'Title', 'Eb/No with Interference');
            grid4 = uigridlayout(tab4, [2,1], ...
                'RowHeight', {'1x',50}, ...
                'Padding', [10 10 10 10]);
            
            ax4 = uiaxes(grid4);
            ax4.Layout.Row = 1;
            ax4.Layout.Column = 1;
            plot(ax4, t, ebNo_I0, '-b', 'LineWidth',2);
            xlabel(ax4, 'Time');
            ylabel(ax4, 'Eb/No (dB)');
            title(ax4, ['Eb/No with Interference for ' groundStationAntennaType]);
            grid(ax4, 'on');
            grid(ax4, 'minor');
            ylim(ax4, 'auto');
            
            btn4 = uibutton(grid4, ...
                'Text', 'Salvează Graficul', ...
                'ButtonPushedFcn', @(btn,event) saveCurrentAxes(ax4, 'EbNo_Interference.png'));
            btn4.Layout.Row = 2;
            btn4.Layout.Column = 1;

            % hide(txs.Pattern);
            % hide(rxGs.Pattern);
            
            % hide(accessObjs);
            % Helper: Calculează factorul de suprapunere spectrală
            function overlapFactor = getOverlapFactor(txFreq, txBW, interferenceFreq, interferenceBW)
                % Limitele benzilor
                txLimits  = [txFreq - txBW/2, txFreq + txBW/2];
                intLimits = [interferenceFreq - interferenceBW/2, ...
                             interferenceFreq + interferenceBW/2];
            
                % 1) Nici o suprapunere
                if intLimits(2) < txLimits(1) || intLimits(1) > txLimits(2)
                    overlapFactor = 0;
                    return;
                end
            
                % 2) Întreaga bandă de interferenţă înăuntrul benzii de transmisie
                if intLimits(2) <= txLimits(2) && intLimits(1) >= txLimits(1)
                    overlapFactor = 1;
                    return;
                end
            
                % 3) Banda de transmisie în interiorul benzii de interferenţă
                if intLimits(2) >  txLimits(2) && intLimits(1) < txLimits(1)
                    overlapFactor = txBW / interferenceBW;
                    return;
                end
            
                % 4) Parţial, marginea din stânga
                if intLimits(2) <= txLimits(2) && intLimits(1) < txLimits(1)
                    overlapFactor = (intLimits(2) - txLimits(1)) / interferenceBW;
                    return;
                end
            
                % 5) Parţial, marginea din dreapta
                overlapFactor = (txLimits(2) - intLimits(1)) / interferenceBW;
            end

            % --- Funcție locală pentru salvare grafic
            function saveCurrentAxes(ax, defaultName)
                [file, path] = uiputfile('*.png', 'Salvează figura', defaultName);
                if isequal(file,0)
                    return;
                end
                exportgraphics(ax, fullfile(path, file), 'Resolution', 300);
            end

            function T = HelperGetNoiseTemperature(freqHz, gs)
                % Calculează temperatura totală de zgomot a GS pe baza
                % frecvenței și a tipului de antenă selectat în gs.AntennaSelection.
                
                % 1) Parametri de bază
                T0      = 290;                 % Temperatura de referință [K]
                freqGHz = freqHz / 1e9;        % Convertim în GHz pentru model
                
                % 2) Componenta de zgomot de mediu dependentă de frecvență
                %    (exemplu: crește liniar cu GHz, coeficient 5 K/GHz)
                T_env = 5 * freqGHz;           % [K]
                
                % 3) Determinăm Noise Figure (dB) pe baza antenei
                switch gs.AntennaSelection
                    case 'Gaussian Antenna'
                        NFdB = 1.5;
                    case 'Parabolic Reflector'
                        NFdB = 2.5;
                    otherwise
                        NFdB = 3;
                end
                
                % 4) Factor de zgomot și temperatura receptorului
                F    = 10^(NFdB/10);
                T_rx = T0 * (F - 1);           % [K]
                
                % 5) Temperatura totală de zgomot
                %    sumăm referința, mediu și receptor
                T = T0 + T_env + T_rx;
            end
        end

        % Button pushed function: AnalizaAntenaButton
        function AnalizaAntenaButtonPushed(app, event)
            fig = uifigure('Name','P.618 Analysis & Antenna Sizing','WindowState','maximized');
            % Two panels + button row
            mainGrid = uigridlayout(fig, [2,2], ...
                'RowHeight',{'1x','fit'}, 'ColumnWidth',{'0.45x','0.55x'}, ...
                'Padding',10, 'RowSpacing',10, 'ColumnSpacing',20);
        
            %=== Panel 1: Propagation Parameters ===
            pnlProp = uipanel(mainGrid, 'Title','ITU-R P.618 Propagation Parameters','FontWeight','bold');
            pnlProp.Layout.Row = 1; pnlProp.Layout.Column = 1;
            g1 = uigridlayout(pnlProp, [9,2], 'Padding',10, 'RowSpacing',5, 'ColumnSpacing',10);
            labelsProp   = { ...
                'Frequency (GHz)', 'Station Height (km)', 'Water Vapor Density (g/m³)', ...
                'Total Columnar Water Content (mm)', 'Wet Refractivity (N-units)', 'Rain Rate (mm/h)', ...
                'GS Latitude (°)', 'GS Longitude (°)', 'Outage Probability (%)'};
            defaultsProp = [12,1.5,7.5,16.5,300,12,0,0,1];
            tipsProp     = { ...
                'Operating frequency in GHz', 'Ground station antenna height above sea level in km', ...
                'Water vapor density at ground level', 'Total water content above station', ...
                'Refractivity at surface under wet conditions', 'Rain intensity threshold', ...
                'Ground station latitude', 'Ground station longitude', 'Annual percentage of time exceeded'};
            fld = struct();
            for i = 1:numel(labelsProp)
                uilabel(g1, 'Text', [labelsProp{i} ':']);
                f = uieditfield(g1, 'numeric', 'Limits',[0 Inf], 'Tooltip', tipsProp{i});
                f.Value = defaultsProp(i);
                fld.(['P' num2str(i)]) = f;
            end
        
            %=== Panel 2: Antenna & Link Parameters ===
            pnlAnt = uipanel(mainGrid, 'Title','Antenna & Link Parameters','FontWeight','bold');
            pnlAnt.Layout.Row = 1; pnlAnt.Layout.Column = 2;
            g2 = uigridlayout(pnlAnt, [10,2], 'Padding',10, 'RowSpacing',5, 'ColumnSpacing',10);
            labelsAnt   = { ...
                'GS Latitude (°)', 'GS Longitude (°)', 'Satellite EIRP (dBW)', 'Satellite Altitude (km)', ...
                'Satellite Frequency (GHz)', 'Antenna Efficiency (%)', 'Radome Loss (dB)', 'Pointing Loss (dB)', ...
                'Receiver Temperature (K)', 'Symbol Rate (sym/s)', 'Implementation Loss (dB)', 'Required Es/No (dB)'};
            defaultsAnt = [1.29,103.5,27,500,8.2,63.1,0.74,0.2,100,1e8,2.5,17.8];
            tipsAnt     = { ...
                'Ground station latitude', 'Ground station longitude', 'Satellite EIRP', ...
                'Orbital altitude', 'Downlink frequency', 'Feed/reflector efficiency', ...
                'Loss through radome', 'Pointing alignment loss', 'System noise temperature', ...
                'Symbol rate', 'Receiver implementation loss', 'Minimum Eb/No requirement'};
            fld2 = struct();
            for i = 1:numel(labelsAnt)
                uilabel(g2, 'Text', [labelsAnt{i} ':']);
                f = uieditfield(g2, 'numeric', 'Tooltip', tipsAnt{i});
                f.Value = defaultsAnt(i);
                fld2.(['A' num2str(i)]) = f;
            end
            % Text inputs
            uilabel(g2, 'Text', 'Antenna Diameters (m, comma-separated):');
            diamFld = uieditfield(g2,'text','Tooltip','e.g. 3,5,7,9'); diamFld.Value = '3,5,7,9';
            uilabel(g2, 'Text', 'Elevation Angles (°, comma-separated):');
            elFld   = uieditfield(g2,'text','Tooltip','e.g. 5,10,15,20'); elFld.Value   = '5,10,15,20';
            uilabel(g2, 'Text', 'Polarization (Single/Dual):');
            polFld  = uieditfield(g2,'text','Tooltip','Enter Single or Dual'); polFld.Value  = 'Dual';
        
            %=== Calculate Button ===
            calcBtn = uibutton(mainGrid, 'Text','Calculeaza', 'ButtonPushedFcn',@onCalculate);
            calcBtn.Layout.Row = 2; calcBtn.Layout.Column = [1 2];
            calcBtn.HorizontalAlignment = 'center';
        
            function onCalculate(~,~)
                d = uiprogressdlg(fig, 'Title','Calculam datele','Indeterminate','on');
                % Read Propagation params
                p = cell2mat(arrayfun(@(i)fld.(['P' num2str(i)]).Value, 1:numel(labelsProp), 'UniformOutput',false));
                freq = p(1)*1e9; stH = p(2); wv = p(3); tcc = p(4); wsr = p(5);
                rain = p(6); lat = p(7); lon = p(8); pct = p(9);
                % Read Antenna params
                a = cell2mat(arrayfun(@(i)fld2.(['A' num2str(i)]).Value, 1:numel(labelsAnt), 'UniformOutput',false));
                satEIRP = a(3); satAlt = a(4); satFreq = a(5)*1e9; eff = a(6)/100; rad = a(7);
                ptg = a(8); rt = a(9); sr = a(10); impl = a(11); esno = a(12);
                diam = str2double(split(diamFld.Value,',')); el = str2double(split(elFld.Value,',')); pol = polFld.Value;
                % Load digital maps if missing
                if ~exist('maps.mat','file')
                    untar('https://www.mathworks.com/supportfiles/spc/P618/ITURDigitalMaps.tar.gz','.'); addpath(cd);
                end
                % ITU-R P.618 loss calculation
                cfgP = p618Config('Frequency',freq,'Latitude',lat,'Longitude',lon,'TotalAnnualExceedance',pct);
                pl = p618PropagationLosses(cfgP,'StationHeight',stH,'WaterVaporDensity',wv, ...
                    'TotalColumnarContent',tcc,'WetSurfaceRefractivity',wsr,'RainRate',rain);
                Tpl = struct2table(pl,'AsArray',false);
                % Link margin vs diameter & elevation
                skies = {'n','y'}; labelsS = {'rain','clear'};
                margins = zeros(numel(diam), numel(el), 2);
                for s = 1:2
                    for iEl = 1:numel(el)
                        for iD = 1:numel(diam)
                            [ms,md] = HelperLinkMargin(eff, diam(iD), el(iEl), skies{s}, ...
                                satFreq, satEIRP, satAlt, rt, sr, impl, esno, rad, ptg, rain);
                            margins(iD,iEl,s) = strcmpi(pol,'Dual')*md + strcmpi(pol,'Single')*ms;
                        end
                    end
                end
                Tm = array2table([diam, margins(:,:,1)], 'VariableNames', ['Diameter'; strcat('M',string(el),'deg')]);
                % Display results in one figure with tabs
                f2 = uifigure('Name','Analysis Results','Position',[200 200 1000 650]);
                tg2 = uitabgroup(f2,'Position',[10 10 980 630]);
                % Plot tab
                t1 = uitab(tg2,'Title','Margin Plot'); ax = uiaxes(t1,'Position',[20 20 940 580]); hold(ax,'on');
                styles = {'-o','--o'}; lg = {};
                for s = 1:2
                    for iEl = 1:numel(el)
                        plot(ax, diam, margins(:,iEl,s), styles{s}, 'LineWidth',1.5);
                        lg{end+1} = sprintf('%d° %s', el(iEl), labelsS{s});
                    end
                end
                xlabel(ax,'Antenna Diameter (m)'); ylabel(ax,'Link Margin (dB)');
                legend(ax, lg, 'Location','southeast'); grid(ax,'on');
                % Tables tab
                t2 = uitab(tg2,'Title','Tables'); gl = uigridlayout(t2,[1,2],'Padding',10);
                % Remove unsupported 'Title' property from uitable
                uitable(gl,'Data',Tpl);
                uitable(gl,'Data',Tm);
                close(d);
            end
        
            function [mS,mD] = HelperLinkMargin(eff, d, el, sky, freq, eirp, alt, rt, sr, impl, esno, rad, ptg, rain)
                c = physconst('LightSpeed'); lambda = c/freq;
                G = 10*log10(eff) + 20*log10((pi*d)/lambda);
                Re = 6371; rkm = sqrt((Re+alt)^2 - (Re*sin(deg2rad(el)))^2) - Re*cos(deg2rad(el)); R = rkm*1e3;
                cfg = p618Config('Frequency',freq,'ElevationAngle',el,'Latitude',0,'Longitude',0,'TotalAnnualExceedance',1);
                if sky=='y'
                    [att,~,tsky] = p618PropagationLosses(cfg,'StationHeight',0);
                else
                    [att,~,tsky] = p618PropagationLosses(cfg,'StationHeight',0,'RainRate',rain);
                end
                FSPL = 20*log10(4*pi*R/lambda); kdbw = 10*log10(physconst('Boltzmann'));
                CNo = eirp + G - att.At - FSPL - rad - ptg - (kdbw + 10*log10(rt+tsky)); EbNo = CNo - 10*log10(sr);
                mS = EbNo - esno - impl; mD = mS + 3;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1.3x', '1x', '1x'};
            app.GridLayout.RowHeight = {'1x', '2x', '2x'};

            % Create ManagerSatelitButton
            app.ManagerSatelitButton = uibutton(app.GridLayout, 'push');
            app.ManagerSatelitButton.ButtonPushedFcn = createCallbackFcn(app, @ManagerSatelitButtonPushed, true);
            app.ManagerSatelitButton.BackgroundColor = [0 0.4471 0.7412];
            app.ManagerSatelitButton.FontName = 'Times New Roman';
            app.ManagerSatelitButton.FontSize = 16;
            app.ManagerSatelitButton.FontWeight = 'bold';
            app.ManagerSatelitButton.Layout.Row = 1;
            app.ManagerSatelitButton.Layout.Column = 1;
            app.ManagerSatelitButton.Text = 'Manager Satelit';

            % Create Panel_2
            app.Panel_2 = uipanel(app.GridLayout);
            app.Panel_2.Layout.Row = 2;
            app.Panel_2.Layout.Column = 1;

            % Create AdaugFiierTLEButton_2
            app.AdaugFiierTLEButton_2 = uibutton(app.Panel_2, 'push');
            app.AdaugFiierTLEButton_2.ButtonPushedFcn = createCallbackFcn(app, @AdaugFiierTLEButton_2Pushed, true);
            app.AdaugFiierTLEButton_2.FontName = 'Times New Roman';
            app.AdaugFiierTLEButton_2.FontWeight = 'bold';
            app.AdaugFiierTLEButton_2.Position = [7 150 109 23];
            app.AdaugFiierTLEButton_2.Text = 'Adaugă Fișier TLE';

            % Create fiierEditField
            app.fiierEditField = uieditfield(app.Panel_2, 'text');
            app.fiierEditField.Position = [121 150 103 22];

            % Create ControlSateliiDropDownLabel
            app.ControlSateliiDropDownLabel = uilabel(app.Panel_2);
            app.ControlSateliiDropDownLabel.HorizontalAlignment = 'right';
            app.ControlSateliiDropDownLabel.FontName = 'Times New Roman';
            app.ControlSateliiDropDownLabel.FontWeight = 'bold';
            app.ControlSateliiDropDownLabel.Position = [132 125 84 22];
            app.ControlSateliiDropDownLabel.Text = 'Control Sateliți';

            % Create ControlSateliiDropDown
            app.ControlSateliiDropDown = uidropdown(app.Panel_2);
            app.ControlSateliiDropDown.Items = {};
            app.ControlSateliiDropDown.ValueChangedFcn = createCallbackFcn(app, @ControlSateliiDropDownValueChanged, true);
            app.ControlSateliiDropDown.HandleVisibility = 'off';
            app.ControlSateliiDropDown.Position = [132 104 100 22];
            app.ControlSateliiDropDown.Value = {};

            % Create AfieazsatelitCheckBox
            app.AfieazsatelitCheckBox = uicheckbox(app.Panel_2);
            app.AfieazsatelitCheckBox.ValueChangedFcn = createCallbackFcn(app, @AfieazsatelitCheckBoxValueChanged2, true);
            app.AfieazsatelitCheckBox.Text = 'Afișează satelit';
            app.AfieazsatelitCheckBox.Position = [131 78 103 22];

            % Create UrmalasolCheckBox
            app.UrmalasolCheckBox = uicheckbox(app.Panel_2);
            app.UrmalasolCheckBox.ValueChangedFcn = createCallbackFcn(app, @UrmalasolCheckBoxValueChanged2, true);
            app.UrmalasolCheckBox.Text = 'Urma la sol';
            app.UrmalasolCheckBox.Position = [131 56 83 22];

            % Create tergeButton
            app.tergeButton = uibutton(app.Panel_2, 'push');
            app.tergeButton.ButtonPushedFcn = createCallbackFcn(app, @tergeButtonPushed2, true);
            app.tergeButton.FontWeight = 'bold';
            app.tergeButton.Position = [154 6 75 23];
            app.tergeButton.Text = 'Șterge';

            % Create ControlConstelaieDropDownLabel
            app.ControlConstelaieDropDownLabel = uilabel(app.Panel_2);
            app.ControlConstelaieDropDownLabel.HorizontalAlignment = 'center';
            app.ControlConstelaieDropDownLabel.FontName = 'Times New Roman';
            app.ControlConstelaieDropDownLabel.FontWeight = 'bold';
            app.ControlConstelaieDropDownLabel.Position = [7 125 106 22];
            app.ControlConstelaieDropDownLabel.Text = 'Control Constelație';

            % Create ControlConstelaieDropDown
            app.ControlConstelaieDropDown = uidropdown(app.Panel_2);
            app.ControlConstelaieDropDown.Items = {};
            app.ControlConstelaieDropDown.DropDownOpeningFcn = createCallbackFcn(app, @ControlConstelaieDropDownOpening, true);
            app.ControlConstelaieDropDown.ValueChangedFcn = createCallbackFcn(app, @ControlConstelaieDropDownValueChanged, true);
            app.ControlConstelaieDropDown.Position = [7 104 115 22];
            app.ControlConstelaieDropDown.Value = {};

            % Create AfieazConstelaieCheckBox
            app.AfieazConstelaieCheckBox = uicheckbox(app.Panel_2);
            app.AfieazConstelaieCheckBox.ValueChangedFcn = createCallbackFcn(app, @AfieazConstelaieCheckBoxValueChanged, true);
            app.AfieazConstelaieCheckBox.Text = {'Afișează '; 'Constelație'};
            app.AfieazConstelaieCheckBox.Position = [7 70 139 29];

            % Create FotografieazCheckBox
            app.FotografieazCheckBox = uicheckbox(app.Panel_2);
            app.FotografieazCheckBox.ValueChangedFcn = createCallbackFcn(app, @FotografieazCheckBoxValueChanged, true);
            app.FotografieazCheckBox.Text = 'Fotografiează';
            app.FotografieazCheckBox.Position = [131 35 95 22];

            % Create Panel_4
            app.Panel_4 = uipanel(app.GridLayout);
            app.Panel_4.Layout.Row = 3;
            app.Panel_4.Layout.Column = 1;
            app.Panel_4.FontName = 'Times New Roman';
            app.Panel_4.FontWeight = 'bold';

            % Create ParametriiSatelitTextAreaLabel
            app.ParametriiSatelitTextAreaLabel = uilabel(app.Panel_4);
            app.ParametriiSatelitTextAreaLabel.HorizontalAlignment = 'center';
            app.ParametriiSatelitTextAreaLabel.FontName = 'Times New Roman';
            app.ParametriiSatelitTextAreaLabel.FontWeight = 'bold';
            app.ParametriiSatelitTextAreaLabel.Position = [0 153 235 22];
            app.ParametriiSatelitTextAreaLabel.Text = 'Parametrii Satelit';

            % Create ParametriiSatelitTextArea
            app.ParametriiSatelitTextArea = uitextarea(app.Panel_4);
            app.ParametriiSatelitTextArea.Position = [0 1 235 155];

            % Create Panel_7
            app.Panel_7 = uipanel(app.GridLayout);
            app.Panel_7.Layout.Row = 3;
            app.Panel_7.Layout.Column = 3;

            % Create nchideButton
            app.nchideButton = uibutton(app.Panel_7, 'push');
            app.nchideButton.ButtonPushedFcn = createCallbackFcn(app, @nchideButtonPushed, true);
            app.nchideButton.Position = [132 1 46 27];
            app.nchideButton.Text = 'Închide';

            % Create StartButton
            app.StartButton = uibutton(app.Panel_7, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.Position = [132 31 46 24];
            app.StartButton.Text = 'Start';

            % Create StatusLabel
            app.StatusLabel = uilabel(app.Panel_7);
            app.StatusLabel.Tag = 'StatusLabel';
            app.StatusLabel.HorizontalAlignment = 'center';
            app.StatusLabel.WordWrap = 'on';
            app.StatusLabel.FontName = 'Times New Roman';
            app.StatusLabel.FontSize = 10;
            app.StatusLabel.FontWeight = 'bold';
            app.StatusLabel.Position = [1 1 132 54];
            app.StatusLabel.Text = 'Status: Ready';

            % Create RestartButton
            app.RestartButton = uibutton(app.Panel_7, 'push');
            app.RestartButton.ButtonPushedFcn = createCallbackFcn(app, @RestartButtonPushed, true);
            app.RestartButton.Position = [117 101 64 24];
            app.RestartButton.Text = 'Restart';

            % Create OpreteButton
            app.OpreteButton = uibutton(app.Panel_7, 'push');
            app.OpreteButton.ButtonPushedFcn = createCallbackFcn(app, @OpreteButtonPushed2, true);
            app.OpreteButton.Position = [117 126 64 23];
            app.OpreteButton.Text = 'Oprește';

            % Create PorneteButton
            app.PorneteButton = uibutton(app.Panel_7, 'push');
            app.PorneteButton.ButtonPushedFcn = createCallbackFcn(app, @PorneteButtonPushed, true);
            app.PorneteButton.Position = [117 150 64 23];
            app.PorneteButton.Text = 'Pornește';

            % Create DescarcdateleButton
            app.DescarcdateleButton = uibutton(app.Panel_7, 'push');
            app.DescarcdateleButton.FontName = 'Times New Roman';
            app.DescarcdateleButton.FontWeight = 'bold';
            app.DescarcdateleButton.Position = [6 77 96 23];
            app.DescarcdateleButton.Text = 'Descarcă datele';

            % Create nchidescenariuButton
            app.nchidescenariuButton = uibutton(app.Panel_7, 'push');
            app.nchidescenariuButton.ButtonPushedFcn = createCallbackFcn(app, @nchidescenariuButtonPushed, true);
            app.nchidescenariuButton.Position = [109 63 70 37];
            app.nchidescenariuButton.Text = {'Închide'; 'scenariu'};

            % Create DurataEditFieldLabel
            app.DurataEditFieldLabel = uilabel(app.Panel_7);
            app.DurataEditFieldLabel.HorizontalAlignment = 'right';
            app.DurataEditFieldLabel.Position = [-4 127 42 22];
            app.DurataEditFieldLabel.Text = 'Durata';

            % Create DurataEditField
            app.DurataEditField = uieditfield(app.Panel_7, 'text');
            app.DurataEditField.HorizontalAlignment = 'center';
            app.DurataEditField.Position = [25 149 84 22];
            app.DurataEditField.Value = '8';

            % Create DropDown
            app.DropDown = uidropdown(app.Panel_7);
            app.DropDown.Items = {'minute', 'ore', 'ore și minute(hh:mm)', 'zile'};
            app.DropDown.Position = [40 128 69 22];
            app.DropDown.Value = 'ore';

            % Create Panel_3
            app.Panel_3 = uipanel(app.GridLayout);
            app.Panel_3.Layout.Row = 2;
            app.Panel_3.Layout.Column = 2;

            % Create ControlStaieDropDownLabel
            app.ControlStaieDropDownLabel = uilabel(app.Panel_3);
            app.ControlStaieDropDownLabel.HorizontalAlignment = 'right';
            app.ControlStaieDropDownLabel.FontName = 'Times New Roman';
            app.ControlStaieDropDownLabel.FontWeight = 'bold';
            app.ControlStaieDropDownLabel.Position = [5 150 78 22];
            app.ControlStaieDropDownLabel.Text = 'Control Stație';

            % Create ControlStaieDropDown
            app.ControlStaieDropDown = uidropdown(app.Panel_3);
            app.ControlStaieDropDown.Items = {''};
            app.ControlStaieDropDown.DropDownOpeningFcn = createCallbackFcn(app, @ControlStaieDropDownOpening, true);
            app.ControlStaieDropDown.ValueChangedFcn = createCallbackFcn(app, @ControlStaieDropDownValueChanged, true);
            app.ControlStaieDropDown.Position = [90 150 86 22];
            app.ControlStaieDropDown.Value = '';

            % Create AfieazCheckBox_2
            app.AfieazCheckBox_2 = uicheckbox(app.Panel_3);
            app.AfieazCheckBox_2.ValueChangedFcn = createCallbackFcn(app, @AfieazCheckBox_2ValueChanged, true);
            app.AfieazCheckBox_2.Text = 'Afișează';
            app.AfieazCheckBox_2.Position = [10 125 68 22];

            % Create tergeButton_2
            app.tergeButton_2 = uibutton(app.Panel_3, 'push');
            app.tergeButton_2.ButtonPushedFcn = createCallbackFcn(app, @tergeButton_2Pushed, true);
            app.tergeButton_2.FontWeight = 'bold';
            app.tergeButton_2.Position = [101 6 75 23];
            app.tergeButton_2.Text = 'Șterge';

            % Create AcceslasatelitButton
            app.AcceslasatelitButton = uibutton(app.Panel_3, 'push');
            app.AcceslasatelitButton.ButtonPushedFcn = createCallbackFcn(app, @AcceslasatelitButtonPushed, true);
            app.AcceslasatelitButton.Position = [5 56 97 23];
            app.AcceslasatelitButton.Text = 'Acces la satelit';

            % Create AscundeAccesButton
            app.AscundeAccesButton = uibutton(app.Panel_3, 'push');
            app.AscundeAccesButton.ButtonPushedFcn = createCallbackFcn(app, @AscundeAccesButtonPushed, true);
            app.AscundeAccesButton.Position = [5 29 98 24];
            app.AscundeAccesButton.Text = 'Ascunde Acces';

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.GridLayout);
            app.GridLayout2.ColumnWidth = {'1x'};
            app.GridLayout2.RowHeight = {'1x'};
            app.GridLayout2.Layout.Row = 1;
            app.GridLayout2.Layout.Column = 2;
            app.GridLayout2.BackgroundColor = [1 1 0];

            % Create AdaugstaieButton
            app.AdaugstaieButton = uibutton(app.GridLayout2, 'push');
            app.AdaugstaieButton.ButtonPushedFcn = createCallbackFcn(app, @AdaugstaieButtonPushed, true);
            app.AdaugstaieButton.BackgroundColor = [0.9294 0.6941 0.1255];
            app.AdaugstaieButton.Layout.Row = 1;
            app.AdaugstaieButton.Layout.Column = 1;
            app.AdaugstaieButton.Text = {'Adaugă '; 'stație '};

            % Create ParametriisimularePanel
            app.ParametriisimularePanel = uipanel(app.GridLayout);
            app.ParametriisimularePanel.Title = 'Parametrii simulare';
            app.ParametriisimularePanel.Layout.Row = [1 2];
            app.ParametriisimularePanel.Layout.Column = 3;

            % Create AcoperireButton
            app.AcoperireButton = uibutton(app.ParametriisimularePanel, 'push');
            app.AcoperireButton.ButtonPushedFcn = createCallbackFcn(app, @AcoperireButtonPushed, true);
            app.AcoperireButton.Position = [80 111 99 21];
            app.AcoperireButton.Text = 'Acoperire';

            % Create LinkBudgetButton
            app.LinkBudgetButton = uibutton(app.ParametriisimularePanel, 'push');
            app.LinkBudgetButton.ButtonPushedFcn = createCallbackFcn(app, @LinkBudgetButtonPushed, true);
            app.LinkBudgetButton.Position = [78 63 101 21];
            app.LinkBudgetButton.Text = 'Link Budget';

            % Create InterferenButton
            app.InterferenButton = uibutton(app.ParametriisimularePanel, 'push');
            app.InterferenButton.ButtonPushedFcn = createCallbackFcn(app, @InterferenButtonPushed, true);
            app.InterferenButton.Position = [78 87 101 21];
            app.InterferenButton.Text = 'Interferență';

            % Create SetarestaresimulareLabel
            app.SetarestaresimulareLabel = uilabel(app.ParametriisimularePanel);
            app.SetarestaresimulareLabel.HorizontalAlignment = 'center';
            app.SetarestaresimulareLabel.Position = [110 1 76 29];
            app.SetarestaresimulareLabel.Text = {'Setare stare '; 'simulare'};

            % Create ActualizaretimpButton
            app.ActualizaretimpButton = uibutton(app.ParametriisimularePanel, 'push');
            app.ActualizaretimpButton.ButtonPushedFcn = createCallbackFcn(app, @ActualizaretimpButtonPushed, true);
            app.ActualizaretimpButton.FontWeight = 'bold';
            app.ActualizaretimpButton.Position = [3 4 102 26];
            app.ActualizaretimpButton.Text = 'Actualizare timp';

            % Create StaiesursDropDownLabel
            app.StaiesursDropDownLabel = uilabel(app.ParametriisimularePanel);
            app.StaiesursDropDownLabel.HorizontalAlignment = 'right';
            app.StaiesursDropDownLabel.FontName = 'Times New Roman';
            app.StaiesursDropDownLabel.FontWeight = 'bold';
            app.StaiesursDropDownLabel.Position = [6 230 65 22];
            app.StaiesursDropDownLabel.Text = 'Stație sursă';

            % Create StaiesursDropDown
            app.StaiesursDropDown = uidropdown(app.ParametriisimularePanel);
            app.StaiesursDropDown.Items = {};
            app.StaiesursDropDown.Position = [88 230 89 22];
            app.StaiesursDropDown.Value = {};

            % Create StaiedestinaieDropDownLabel
            app.StaiedestinaieDropDownLabel = uilabel(app.ParametriisimularePanel);
            app.StaiedestinaieDropDownLabel.HorizontalAlignment = 'right';
            app.StaiedestinaieDropDownLabel.FontName = 'Times New Roman';
            app.StaiedestinaieDropDownLabel.FontWeight = 'bold';
            app.StaiedestinaieDropDownLabel.Position = [1 202 87 22];
            app.StaiedestinaieDropDownLabel.Text = 'Stație destinație';

            % Create StaiedestinaieDropDown
            app.StaiedestinaieDropDown = uidropdown(app.ParametriisimularePanel);
            app.StaiedestinaieDropDown.Items = {};
            app.StaiedestinaieDropDown.Position = [92 202 84 22];
            app.StaiedestinaieDropDown.Value = {};

            % Create ConectareButton
            app.ConectareButton = uibutton(app.ParametriisimularePanel, 'push');
            app.ConectareButton.ButtonPushedFcn = createCallbackFcn(app, @ConectareButtonPushed, true);
            app.ConectareButton.Position = [5 173 71 23];
            app.ConectareButton.Text = 'Conectare';

            % Create EditField_2
            app.EditField_2 = uieditfield(app.ParametriisimularePanel, 'text');
            app.EditField_2.HorizontalAlignment = 'center';
            app.EditField_2.Position = [22 30 67 22];
            app.EditField_2.Value = '00:00:00';

            % Create AnalizaAntenaButton
            app.AnalizaAntenaButton = uibutton(app.ParametriisimularePanel, 'push');
            app.AnalizaAntenaButton.ButtonPushedFcn = createCallbackFcn(app, @AnalizaAntenaButtonPushed, true);
            app.AnalizaAntenaButton.Position = [80 136 95 23];
            app.AnalizaAntenaButton.Text = 'Analiza Antena';

            % Create Panel_8
            app.Panel_8 = uipanel(app.GridLayout);
            app.Panel_8.Layout.Row = 3;
            app.Panel_8.Layout.Column = 2;
            app.Panel_8.FontName = 'Times New Roman';
            app.Panel_8.FontWeight = 'bold';

            % Create ParametriiStaieTextAreaLabel
            app.ParametriiStaieTextAreaLabel = uilabel(app.Panel_8);
            app.ParametriiStaieTextAreaLabel.HorizontalAlignment = 'center';
            app.ParametriiStaieTextAreaLabel.FontName = 'Times New Roman';
            app.ParametriiStaieTextAreaLabel.FontWeight = 'bold';
            app.ParametriiStaieTextAreaLabel.Position = [-37 153 235 22];
            app.ParametriiStaieTextAreaLabel.Text = 'Parametrii Stație';

            % Create ParametriiStaieTextArea
            app.ParametriiStaieTextArea = uitextarea(app.Panel_8);
            app.ParametriiStaieTextArea.Position = [1 1 182 157];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = interfataV1_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @manager)

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
