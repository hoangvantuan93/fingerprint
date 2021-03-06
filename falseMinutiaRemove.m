function [pathMap, final_end,final_branch] =falseMinutiaRemove(in,end_list,branch_list,inArea,ridgeOrderMap,edgeWidth)

	
%lay size cua anh
[w,h] = size(in);

% kkhoi tao mang
final_end = [];
final_branch =[];
direct = [];
pathMap = [];

%khoi tao phan tu thu 3 cho end list l� 0 v� branch list = 1
%��nh dau ��u l� �iem cut, ��u l� �iem re nh�nh
end_list(:,3) = 0;
branch_list(:,3) = 1;

% mang chua c�c �iem minutiae
minutiaeList = [end_list;branch_list];
finalList = minutiaeList;

% lay so l�ong minutiae.
[numberOfMinutia,dummy] = size(minutiaeList);
suspectMinList = [];
%% Tim kiem c�c �iem �ac tr�ng kha nghi
% so s�nh c�c minutiae voi nhau.
for i= 1:numberOfMinutia-1
   for j = i+1:numberOfMinutia
       %t�nh khoang c�ch giua 2 v�n
      d =( (minutiaeList(i,1) - minutiaeList(j,1))^2 + (minutiaeList(i,2)-minutiaeList(j,2))^2)^0.5;
      % so s�nh khoang c�ch voi khoang c�ch trung binh giua 2 v�n < -->
      % th�m v�o mang v�n kha nghi
      if d < edgeWidth
          % 2 �iem minutiae cot i v� cot j bi kha nghi l� nhieu.
         suspectMinList =[suspectMinList;[i,j]];
      end;
   end;
end;

%lay so l�ong v�n kha nghi.
[totalSuspectMin,dummy] = size(suspectMinList);
%totalSuspectMin
%% x�t c�c �iem �ac tr�ng kha nghi
for k = 1:totalSuspectMin
    
    %tong gi� tri cot 3 cua �iem �ac tr�ng sai : �iem k�t th�c l� 0 , �iem
    %re nh�nh l� 1 
   typesum = minutiaeList(suspectMinList(k,1),3) + minutiaeList(suspectMinList(k,2),3);
   
   %tr�ong hop i l� re nh�nh j l� cut hoac ng�oc lai --> 1+0 or 0+1
   if typesum == 1
      % branch - end pair. Ti?n h�nh s?a.
      % ki?m tra trong s� �? v�n. n?u �i?m minutiae 1 c� gi� tr? = v?i �i?m
      % minutiae 2 --> c�ng 1 v�ng v�n
      if ridgeOrderMap(minutiaeList(suspectMinList(k,1),1),minutiaeList(suspectMinList(k,1),2) ) ==  ridgeOrderMap(minutiaeList(suspectMinList(k,2),1),minutiaeList(suspectMinList(k,2),2) )
          %g�n t?a �? cho c�c minutia l� -1 
          finalList(suspectMinList(k,1),1:2) = [-1,-1];
	      finalList(suspectMinList(k,2),1:2) = [-1,-1];
      end;
      % tr�?ng h?p i l� r? nh�nh j l� r? nh�nh
   elseif typesum == 2
      % branch - branch pair
      if ridgeOrderMap(minutiaeList(suspectMinList(k,1),1),minutiaeList(suspectMinList(k,1),2) ) ==  ridgeOrderMap(minutiaeList(suspectMinList(k,2),1),minutiaeList(suspectMinList(k,2),2) )
         finalList(suspectMinList(k,1),1:2) = [-1,-1];
	      finalList(suspectMinList(k,2),1:2) = [-1,-1];
      end;
      %tr�?ng h?p l� 2 �i?m c?t.
   elseif typesum == 0
      % end - end pair
      % l?y t?a �? 2 �i?m minutiae c?t
      a = minutiaeList(suspectMinList(k,1),1:3);
      b = minutiaeList(suspectMinList(k,2),1:3);
     
      % neu 2 diem khong nam tren 1 duong van tr�n 1 v�ng v�n
      if ridgeOrderMap(a(1),a(2)) ~=  ridgeOrderMap(b(1),b(2))
          
         % l?y g�c �?nh h�?ng c?c b? c?a �o?n c?t v� path c?a n�.
         % lay goc dinh huong cua 
         [thetaA,pathA,dd,mm] = getLocalTheta(in,a,edgeWidth); 
         [thetaB,pathB,dd,mm] = getLocalTheta(in,b,edgeWidth); 
         
         %the connected line between the two points
         
         thetaC = atan2( (pathA(1,1)-pathB(1,1)), (pathA(1,2) - pathB(1,2)) );
         
         
         angleAB = abs(thetaA-thetaB);
         angleAC = abs(thetaA-thetaC);
         
        % n?u g�c �?nh h�?ng nh? h�n ng�?ng pi/3 -> lo?i ra 
         if ( (or(angleAB < pi/3, abs(angleAB -pi)<pi/3 )) & (or(angleAC < pi/3, abs(angleAC - pi) < pi/3)) )  
            finalList(suspectMinList(k,1),1:2) = [-1,-1];
            finalList(suspectMinList(k,2),1:2) = [-1,-1];
         end;
         
         %n?u 2 �i?m c?t n?m tr�n 1 v�ng v�n
         %remove short ridge later
      elseif  ridgeOrderMap(a(1),a(2)) ==  ridgeOrderMap(b(1),b(2))        
         finalList(suspectMinList(k,1),1:2) = [-1,-1];
         finalList(suspectMinList(k,2),1:2) = [-1,-1];

      end;
   end;
end;

    % v?ng l?p s? l�?ng minutiae
   for k =1:numberOfMinutia
       % tr�?ng h?p n� kh�ng l� v�n �? b? lo?i
      if finalList(k,1:2) ~= [-1,-1]
          % l� v�n c?t
         if finalList(k,3) == 0
             % l?y g�c �?nh h�?ng c?c b? c?a v�n c?t
            [thetak,pathk,dd,mm] = getLocalTheta(in,finalList(k,:),edgeWidth);
            % tr�?ng h?p �? d�i c?a path > �? r?ng v�n
            if size(pathk,1) >= edgeWidth
                % th�m v�o danh s�ch
            	final_end=[final_end;[finalList(k,1:2),thetak]];
                %l?y s? l�?ng �i?m �?c tr�ng v�n c?t
            	[id,dummy] = size(final_end);
                %th�m id v�o path
            	pathk(:,3) = id;
                % th�m path c?a v�n c?t v�o pathmap
            	pathMap = [pathMap;pathk];
            end;
            
          % l� �i?m r? nh�nh
         else
          
            % l?y path v� g�c �?nh h�?ng c?a �i?m r? nh�nh
            [thetak,path1,path2,path3] = getLocalTheta(in,finalList(k,:),edgeWidth);
            % n?u �? d�i c?a c�c path >= �? r?ng v�n th? th�m v�o final end
            if size(path1,1)>=edgeWidth & size(path2,1)>=edgeWidth & size(path3,1)>=edgeWidth
              % th�m v�o v�o m?ng nh�nh 
            final_branch=[final_branch;finalList(k,1:2)];
            % th�m g�c �?nh h�?ng v� t?a �? c?a path1
            final_end=[final_end;[path1(1,1:2),thetak(1)]];
            % l?y s? l�?ng minutiae
            [id,dummy] = size(final_end);
            % g�n id
            path1(:,3) = id;
            %th�m v�o pathmap
            pathMap = [pathMap;path1];
           
             % th�m g�c �?nh h�?ng v� t?a �? c?a path2
            final_end=[final_end;[path2(1,1:2),thetak(2)]];
            path2(:,3) = id+1;
            pathMap = [pathMap;path2];
           
             % th�m g�c �?nh h�?ng v� t?a �? c?a path3
            final_end=[final_end;[path3(1,1:2),thetak(3)]];
				path3(:,3) = id+2;
            pathMap = [pathMap;path3];
           
         	end;
         % final_end: l�u t?a �? v� g�c �?nh h�?ng c?a �i?m �?c tr�ng
         % path_map: l�u �?ng d?n v� id c?a �i?m �?c tr�ng
            
         end;
      end;
   end;
   
   %final_end
   %pathMap
   %edgeWidth      
  
       
         
