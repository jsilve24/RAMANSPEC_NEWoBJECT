classdef ramanexperiment
    
    properties
        ExperimentID
        Notes
        ContainedSamples
    end %End Properties
    
    
    methods
        function exp = ramanexperiment(ExperimentID)
        %RAMANEXPERIMENT RamanExperiment class constructor. 
        % spec = ramanexperiment('ExperimentID') creates ramanspec
        % object from double data, 

            if nargin == 0
                exp.ExperimentID=[];
                exp.Notes=[];
                exp.ContainedSamples = [];
            % elseif nargin == 1
            elseif isa(ExperimentID,'ramanexperiment')
                exp = ExperimentID;
            else
                exp.ExperimentID = ExperimentID;
                exp.Notes = [];
                exp.ContainedSamples = [];
            end
        end
        
        function display(exp)
            % RAMANEXP/DISPLAY Command window display of ramanspec data

            disp('');
            disp([inputname(1),' = ']);
            disp('');           
            get(exp)
            disp('');
        end
    end %End Methods
    methods
        function val = get(exp,varargin)
             propName = varargin;
         if length(varargin) == 1  
            switch char(propName)
                case 'ExperimentID'
                    val = exp.ExperimentID;
                case 'Notes'
                    val = exp.Notes;
                case {'ContainedSampleIDs','ContainedSamples'}
                    val = exp.ContainedSamples;
                otherwise
                    error('Not a valid Property Name')
            end %switch
         elseif isempty(varargin)
            Properties = [];
            PropNames = {'ExperimentID','Notes','ContainedSampleIDs'};
            
            Properties{1} = exp.ExperimentID;

            Properties{2} = exp.Notes;
            
            names =[];
            for i = 1:numel(exp.ContainedSamples)
                speci = exp.ContainedSamples{i};
                names =[names '  ' char(get(speci,'SampleID'))];
            end %end for    

            fprintf([PropNames{1} ': \t' char(Properties{1}) '\n']);           
            fprintf([PropNames{2} ': \t' char(Properties{2}) '\n']);           
            fprintf([PropNames{3} ': ' char(names) '\n']);
            fprintf('\n');
            
         end %if
        end %get function
        
        function exp = set(exp,varargin)
            propertyArgIn = varargin;
            while length(propertyArgIn) >=2
                prop = propertyArgIn{1};
                val = propertyArgIn{2};
                propertyArgIn = propertyArgIn(3:end);
                
                switch prop
                    case 'ExperimentID'
                        exp.ExperimentID = val;
                    case 'Notes'
                        exp.Notes = val;
                    case 'ContainedSampleIDs'
                        exp.ContainedSampleIDs = val;
                    case 'ContainedSamples'
                        exp.ContainedSamples = val;                
                    otherwise
                        error('Not a valid Property Name')
            end %while loop
        end %set function
    end %set function
    end %End Get/Set Methods
    
%     methods
%         function subexp = subsref(exp, S)
%         %SUBREF Defines field name indexing for RAMANEXPERIMENT
%         % Indexing spec(1:3) gives new ramanexperiment object with only data from
%         % first three rows of exp object --- Across all spectral objects contained. 
%         switch S.type
%             case '()'
%                 if max(S.subs{:})<=numel(exp.ContainedSamples)
%                     subexp = exp;
%                     subspec.k = [];
%                     subspec.ri = [];
%                     subspec.k = spec.k(S.subs{:});
%                     subspec.ri = spec.ri(S.subs{:});
%                 else
%                     error('Indexed value out of spectra data range')
%                 end
%             case '{}'
%                 if max(S.subs{:})<=numel(spec)
%                     subspec = spec(S.subs{:});
%                 end %end for
%             case '.'
%                 error('Subreferencing not yet defined for "."')
%         end %Switch End
%         
%         end %END subref function
%         function modspec = subsasgn(spec, S, val)
%         %SUBSASGN Defines index assignment for RAMANSPEC
%         switch S.type
%             case '()'
%                 %TODO: Allow for subsasgn of either k or ri, not only both
%                 %together. 
%                 subspec = spec;
%                 spec.k(S.subs{:}) = val(:,1);
%                 spec.ri(S.subs{:}) = val(:,2);
%             case '{}'
%                 error('Subassignment not yet defined for "{}"')
%             case '.'
%                 error('Subassignment not yet defined for "."')
%         end %Switch End
%         
%         end %END subref function
%     end %End Indexing Methods
end %End Classdef