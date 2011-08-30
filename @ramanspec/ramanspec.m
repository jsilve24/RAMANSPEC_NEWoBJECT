classdef ramanspec
    %This Line is simply to test out GIT
    
    properties (GetAccess = 'public', SetAccess = 'public')
        samplename
        ExperimentID
        SampleID
        Description
        Units
        ExciteWavelength
        Apparatus
        DateTaken
        k
        ri
    end
    properties
        GPeak
        DPeak
    end
    
    
    methods
        function spec = ramanspec(data,samplename)
        %RAMANSPEC RamanSpectra class constructor. 
        % spec = ramanspec(data) creates ramanspec object from double data, 
        % where data(1,:) is the wavenumber data and data(2,:) is the raman
        % intensity data.

            if nargin == 0
                spec.k=[];
                spec.ri=[];
            % elseif nargin == 1
            elseif isa(data,'ramanspec')
                spec = data;
            else
                [length width] = size(data);
                % TODO: Need to fix this to handle Object Arrays
                if width ~= 2
                    disp('Only input a single spectra with Column 1 =Wavenumbers Column 2 = RI')
                    return
                end
                spec.k = data(:,1);
                spec.ri = data(:,2);
                spec.samplename = samplename;
                
            end
        end
        
        function x = double(spec)
            % RAMANSPEC/DOUBLE Convert ramanspec object to double matrix. 

            numspec = length(spec);

            x = [];
            if numel(spec) ~= [0]
                for i = 1:numel(spec) 
                    speci = spec(i);
                    x(:,2*i-1) = speci.k;
                    x(:,2*i) = speci.ri;
                end %end for
            else
            end %end if
        end
        
        function namedisplay(spec)
            % RAMANSPEC/NAMEDISPLAY Command window display of spectra names for
            % ramanspec/display function
            
            fprintf([char(spec.samplename) '\t']);
        end
        
        function display(spec)
            % RAMANSPEC/DISPLAY Command window display of ramanspec data

            disp('');
            disp([inputname(1),' = ']);
            disp(''); 
            
            dspec = double(spec);
            [length width] = size(dspec);
            
            if width == 2 
                namedisplay(spec);
            elseif width == 0
                disp(spec);
            else
                disp('ramanspec array has wrong dimentions');
            end
            fprintf('\n');
            
            line = '';
            for j = 1:length
                for i=1:width/2
                line = [line, sprintf('%g %g \t',dspec(j,2*i-1),dspec(j,2*i))];
                end
                fprintf([line,'\n']);
                line = '';
            end
            disp('');
        end
    end %End Methods
    methods 
        function val = get(spec,varargin)
             propName = varargin;
         if length(varargin) == 1  
            switch char(propName)
                case 'samplename'
                    val = spec.samplename;
                case 'ExperimentID'
                    val = spec.ExperimentID;
                case 'SampleID'
                    val = spec.SampleID;
                case 'Description'
                    val = spec.Description;
                case 'Units'
                    val = spec.Units;
                case 'ExciteWavelength'
                    val = spec.ExciteWavelength;
                case 'Apparatus'
                    val = spec.Apparatus;
                case 'DateTaken'
                    val = spec.DateTaken;
                case 'k'
                    val = spec.k;
                case 'ri'
                    val = spec.ri;
                otherwise
                    error('Not a valid Property Name')
            end %switch
         elseif isempty(varargin)
            for i = 1:numel(spec)
                speci = spec(i);
                Properties = [];
                PropNames = {'SampleName','ExperimentID','SampleID','Description','Units','ExcitationWavelength','Apparatus','DateTaken'};
                Properties{1} = speci.samplename;
                Properties{2} = speci.ExperimentID;
                Properties{3} = speci.SampleID;
                Properties{4} = speci.Description;
                Properties{5} = speci.Units;
                Properties{6} = speci.ExciteWavelength;
                Properties{7} = speci.Apparatus;
                Properties{8} = speci.DateTaken;
 
                for i = 1:8
                    fprintf([PropNames{i} ': \t' char(Properties{i}) '\n']);
                end %end for   
                fprintf('\n');
            end %end for loop
            
      

         end %if
        end %get function
        
        function spec = set(spec,varargin)
            propertyArgIn = varargin;
            while length(propertyArgIn) >=2
                prop = propertyArgIn{1};
                val = propertyArgIn{2};
                propertyArgIn = propertyArgIn(3:end);
                
                switch prop
                    case 'samplename'
                        spec.samplename = val;
                    case 'ExperimentID'
                        spec.ExperimentID = val;
                    case 'SampleID'
                        spec.SampleID = val;
                    case 'Description'
                        spec.Description = val;
                    case 'Units'
                        spec.Units = val;
                    case 'ExciteWavelength'
                        spec.ExciteWavelength = val;
                    case 'Apparatus'
                        spec.Apparatus = val;
                    case 'DateTaken'
                        spec.DateTaken = val;
                    case 'k'
                        spec.k = val;
                    case 'ri'
                        spec.ri = val;
                    otherwise
                        error('Not a valid Property Name')
            end %while loop
        end %set function
    end %set function
    end %End Get/Set Methods
    methods
        function modspec = plus(spec,varargin)
            % First argument is considered the master spectra to which the
            % operations are done on. NOTE: OPERATIONS MUST BE CARRIED OUT
            % AS SPEC+CONSTANT OR SPEC+SPEC NOT CONSTANT+SPEC
            modspec = spec;
            if nargin ==1
               disp('Not enough Input for Plus Operator') 
            
            elseif nargin ==2
               if strcmp(class(varargin{:}), 'ramanspec')
                   argument = double(varargin{:});
                   for i = 1:length(argument)
                       index = find(spec.k == argument(i,1));
                    if ~isempty(index)
                        modspec.ri(index) = spec.ri(index) + argument(i,2);
                    end %end If
                   end %end For
                   
               elseif strcmp(class(varargin{:}), 'double')
                   [arglength argwidth] = size(varargin{:});
                   if arglength == 1
                       modspec.ri = spec.ri+varargin{:};
                   elseif arglength == length(spec.ri)
                       for i = 1:arglength
                           index = find(spec.k == varargin{:}(i));
                        if ~isempty(index)
                            modspec.ri(index) = spec.ri(index) + varargin{:}(i);
                        end %end If
                       end %end For
                       
                       
                   else 
                       error('Argument Dimentions for plus() Do not Match')
                   end %Adding IF              
                end % IF determinign Argument Type
            end % IF determining nargin
        end %Overloaded plus()
        function modspec = minus(spec,varargin)
            % First argument is considered the master spectra to which the
            % operations are done on.
            modspec = spec;
            if nargin ==1
               disp('Not enough Input for Minus Operator') 
            
            elseif nargin ==2
               if strcmp(class(varargin{:}), 'ramanspec')
                   argument = double(varargin{:});
                   for i = 1:length(argument)
                       index = find(spec.k == argument(i,1));
                    if ~isempty(index)
                        modspec.ri(index) = spec.ri(index) - argument(i,2);
                    end %end If
                   end %end For
                   
               elseif strcmp(class(varargin{:}), 'double')
                   [arglength argwidth] = size(varargin{:});
                   if arglength == 1
                       modspec.ri = spec.ri - varargin{:};
                   elseif arglength == length(spec.ri)
                       for i = 1:arglength
                           index = find(spec.k == varargin{:}(i));
                        if ~isempty(index)
                            modspec.ri(index) = spec.ri(index) - varargin{:}(i);
                        end %end If
                       end %end For
                       
                       
                   else 
                       error('Argument Dimentions for plus() Do not Match')
                   end %Adding IF              
                end % IF determinign Argument Type
            end % IF determining nargin
        end %Overloaded minus()
        function modspec = rdivide(spec,varargin)
            % First argument is considered the master spectra to which the
            % operations are done on.
            modspec = spec;
            if nargin ==1
               disp('Not enough Input for rdivide Operator') 
            
            elseif nargin ==2
               if strcmp(class(varargin{:}), 'ramanspec')
                   argument = double(varargin{:});
                   for i = 1:length(argument)
                       index = find(spec.k == argument(i,1));
                    if ~isempty(index)
                        modspec.ri(index) = spec.ri(index) ./ argument(i,2);
                    end %end If
                   end %end For
                   
               elseif strcmp(class(varargin{:}), 'double')
                   [arglength argwidth] = size(varargin{:});
                   if arglength == 1
                       modspec.ri = spec.ri ./ varargin{:};
                   elseif arglength == length(spec.ri)
                       for i = 1:arglength
                           index = find(spec.k == varargin{:}(i));
                        if ~isempty(index)
                            modspec.ri(index) = spec.ri(index) ./ varargin{:}(i);
                        end %end If
                       end %end For
                       
                       
                   else 
                       error('Argument Dimentions for plus() Do not Match')
                   end %Adding IF              
                end % IF determinign Argument Type
            end % IF determining nargin
        end %Overloaded './' rdivide()
    end %Overloaded Arithmetic Operators
    methods
        function subspec = subsref(spec, S)
        %SUBREF Defines field name indexing for RAMANSPEC
        %Indexing spec(1:3) gives new ramanspec object with only data from
        %first three rows of spec object. 
        switch S.type
            case '()'
                if max(S.subs{:})<=max(spec.k)
                    subspec = spec;
                    subspec.k = [];
                    subspec.ri = [];
                    subspec.k = spec.k(S.subs{:});
                    subspec.ri = spec.ri(S.subs{:});
                else
                    error('Indexed value out of spectra data range')
                end
            case '{}'
                if max(S.subs{:})<=numel(spec)
                    subspec = spec(S.subs{:});
                end %end for
                
% %                 disp(spec(1));
% %                 disp(spec(2));
            case '.'
                error('Subreferencing not yet defined for "."')
        end %Switch End
        
        end %END subref function
        function modspec = subsasgn(spec, S, val)
        %SUBSASGN Defines index assignment for RAMANSPEC
        switch S.type
            case '()'
                %TODO: Allow for subsasgn of either k or ri, not only both
                %together. 
                modspec = spec;
                modspec.k(S.subs{:}) = val(:,1);
                modspec.ri(S.subs{:}) = val(:,2);
            case '{}'
                if max(S.subs{:} <= numel(spec))
                    modspec(S.subs{:}) = val(:);
                end % end if
%                 error('Subassignment not yet defined for "{}"')
            case '.'
                error('Subassignment not yet defined for "."')
        end %Switch End
        
        end %END subref function
    end %End Indexing Methods
end %End Classdef   




            