%% Copyright (C) 2012 Roberto Ripio
%%
%% This program is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2 of the License, or
%% (at your option) any later version.
%%
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public License
%% along with this program; if not, write to the Free Software
%% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%%
%% This function is part of DSD

%% usage: imp = crossLinear(fs,m,nc,fl,fh)
%%
%% Obtiene el filtro FIR de fase lineal y alta pendiente.
%%
%% imp = Coeficientes del filtro FIR.
%% fs = Frecuencia de muestreo.
%% m = N�mero de muestras.
%% nc = N�mero de ciclos del impulso.
%% fl = Frecuencia de corte inferior (pasaaltos). 0 para pasabajos.
%% fh = Frecuencia de corte superior (pasabajos). 0 para pasaaltos.

function imp=crossLinear(fs,m,nc,fl,fh);
    
    wl=fl/fs;
    wh=fh/fs;
	
	if (fl != 0) 
		ll=nc*fs/fl;
		ll=ll+1-mod(ll,2);
		if ll >= m
			ll=m-1;
		end
		tl=(-floor(ll/2):floor(ll/2))'; % column vector
		impl=centerimp(sinc(2*wl*tl)*(2*wl).*blackmanharris(ll),m);
	end
	if (fh != 0) 
		lh=nc*fs/fh;
		lh=lh+1-mod(lh,2);
		if lh >= m
			lh=m-1;
		end
		th=(-floor(lh/2):floor(lh/2))'; % column vector
		imph=centerimp(sinc(2*wh*th)*(2*wh).*blackmanharris(lh),m);
	end
	
    
	if (fh == 0 & fl != 0) % high-pass filter
		imp=centerimp(deltacentered(ll),m)-impl;
	elseif (fh != 0 & fl == 0) % low-pass filter
		imp=imph;
	elseif (fh != 0 & fl != 0) % band-pass filter
		imp=imph-impl;
	elseif (fh == 0 & fl == 0) % no filter (delta)
		imp=centerimp(deltacentered(m-1),m);
	end;
	% imp=imp(:); %force column vector
    
end
