function [delTauG] = getIonoDelay(ionodata,fc,rRx,rSv,tGPS,model)
% getIonoDelay : Return a model-based estimate of the ionospheric delay
% experienced by a transionospheric GNSS signal as it
% propagates from a GNSS SV to the antenna of a terrestrial
% GNSS receiver.
%
% INPUTS
%
% ionodata ------- Structure containing a parameterization of the
% ionosphere that is valid at time tGPS. The structure is
% defined differently depending on what ionospheric model
% is selected:
% broadcast --- For the broadcast (Klobuchar) model, ionodata
% is a structure containing the following fields:
% alpha0 ... alpha3 -- power series expansion coefficients
% for amplitude of ionospheric TEC
% beta0 .. beta3 -- power series expansion coefficients
% for period of ionospheric plasma density cycle
% Other models TBD ...
%
% fc ------------- Carrier frequency of the GNSS signal, in Hz.
%
% rRx ------------ A 3-by-1 vector representing the receiver antenna position
% at the time of receipt of the signal, expressed in meters
% in the ECEF reference frame.
%
% rSv ------------ A 3-by-1 vector representing the space vehicle antenna
% position at the time of transmission of the signal,
% expressed in meters in the ECEF reference frame.
%
% tGPS ----------- A structure containing the true GPS time of receipt of
% the signal. The structure has the following fields:
% week -- unambiguous GPS week number
% seconds -- seconds (including fractional seconds) of the
% GPS week
%
% model ---------- A string identifying the model to be used in the
% computation of the ionospheric delay:
% broadcast --- The broadcast (Klobuchar) model.
% Other models TBD ...
%
% OUTPUTS
%
% delTauG -------- Modeled scalar excess group ionospheric delay experienced
% by the transionospheric GNSS signal, in seconds.
%
%+------------------------------------------------------------------------------+
% References: For the broadcast (Klobuchar) model, see IS-GPS-200F
% pp. 128-130.
% Reference:"GPS Theory and application",edited by B.Parkinson,J.Spilker,   *
% Reference: http://www.navipedia.net/index.php/Klobuchar_Ionospheric_Model
%+==============================================================================+

%initialize alpha and beta
alpha = ionodata(1:4);
beta = ionodata(5:8);

%find total time in seconds of SV
t = tGPS(1)*1575 + tGPS(2);

%transform from ECEF to geodetic
geod_rx_lla = ecef2lla(rRx, 'WGS84');
geod_sv_lla = ecef2lla(rSv, 'WGS84');

%find Elevation and Azimuth
[E,A] = Calc_Azimuth_Elevation(rRx, rSv);
E = E/pi;
A = A/pi;

earth_angle = .0137/(E + .11)-.22;

Ipp_lat = geod_rx_lla(1) + earth_angle*cos(A);

if Ipp_lat > .416
    Ipp_lat = .416;
elseif Ipp_lat < -.416
    Ipp_lat = .416;
end

Ipp_long = geod_rx_lla(2) + earth_angle*sin(A)/cos(Ipp_lat);

geom_lat_Ipp = Ipp_lat + .064*cos(Ipp_long-1.617);

Ipp_local_time = 43200*Ipp_long + t;

while Ipp_local_time >= 86400
    Ipp_local_time = Ipp_local_time - 86400;    
end

while Ipp_local_time < 0
        Ipp_local_time = Ipp_local_time + 86400;
end

I_amp_delay = 0;
for n=1:4
    I_amp_delay = I_amp_delay + alpha(n)*geom_lat_Ipp;
end
if I_amp_delay < 0
    I_amp_delay = 0;
end

I_period_delay = 0;
for n=1:4
    I_period_delay = I_period_delay + beta(n)*geom_lat_Ipp;
end
if I_period_delay < 72000
    I_period_delay = 72000;
end

I_phase_delay = 2*pi*(Ipp_local_time)/I_period_delay;

slant_factor = 1 + 16*(.53 + E)^3;

if abs(I_phase_delay) <= 1.57
    Iono_delay = 5*1E-9 + I_amp_delay*(1 - I_phase_delay^2/2 ...
        + I_phase_delay^4/24);
elseif abs(I_phase_delay) >= 1.57
    Iono_delay = 5*1E-9 * slant_factor;   
end
    
delTauG = Iono_delay;

%This Function Compute Azimuth and Elevation of satellite from reciever 
%CopyRight By Moein Mehrtash
%************************************************************************
% Written by Moein Mehrtash, Concordia University, 3/21/2008            *
% Email: moeinmehrtash@yahoo.com                                        *
%************************************************************************           
%    ==================================================================
%    Input :                                                            *
%        Pos_Rcv       : XYZ position of reciever               (Meter) *
%        Pos_SV        : XYZ matrix position of GPS satellites  (Meter) *
%    Output:                                                            *
%        E             :Elevation (Rad)                                 *
%        A             :Azimuth   (Rad)                                 *
%************************************************************************           
function [E,A]=Calc_Azimuth_Elevation(Pos_Rcv,Pos_SV);

R=Pos_SV-Pos_Rcv;               %vector from Reciever to Satellite

GPS = ECEF2GPS(Pos_Rcv);        %Lattitude and Longitude of Reciever
Lat=GPS(1);Lon=GPS(2);

ENU=XYZ2ENU(R,Lat,Lon);
Elevation=asin(ENU(3)/norm(ENU));
Azimuth=atan2(ENU(1)/norm(ENU),ENU(2)/norm(ENU));
E=Elevation;
A=Azimuth;

% convert ECEF coordinates to local East, North, Up 
%****************************************************************************
% Written by Moein Mehrtash, Concordia University, 3/21/2008                *
% Email: moeinmehrtash@yahoo.com                                            *
%****************************************************************************
% Reference:"GPS Theory and application",edited by B.Parkinson,J.Spilker,   *
%****************************************************************************           
function ENU= XYZ2ENU(A,Phi,Lambda) 
  XYZ2ENU=[-sin(Lambda) cos(Lambda) 0;
           -sin(Phi)*cos(Lambda) -sin(Phi)*sin(Lambda) cos(Phi);
           cos(Phi)*cos(Lambda) cos(Phi)*sin(Lambda)  sin(Phi)];
 
  ENU=XYZ2ENU*A'; 

% ECEF2LLA - convert earth-centered earth-fixed (ECEF)
%            cartesian coordinates to latitude, longitude,
%            and altitude
%
% USAGE:
% [lat,lon,alt] = ECEF2GPS(x,y,z)
%
% lat = geodetic latitude (radians)
% lon = longitude (radians)
% alt = height above WGS84 ellipsoid (m)
% x = ECEF X-coordinate (m)
% y = ECEF Y-coordinate (m)
% z = ECEF Z-coordinate (m)
%
% Notes: (1) This function assumes the WGS84 model.
%        (2) Latitude is customary geodetic (not geocentric).
%        (3) Inputs may be scalars, vectors, or matrices of the same
%            size and shape. Outputs will have that same size and shape.
%        (4) Tested but no warranty; use at your own risk.
%        (5) Michael Kleder, April 2006

function GPS = ECEF2GPS(Pos)
x=Pos(1);
y=Pos(2);
z=Pos(3);


% WGS84 ellipsoid constants:
a = 6378137;
e = 8.1819190842622e-2;

% calculations:
b   = sqrt(a^2*(1-e^2));
ep  = sqrt((a^2-b^2)/b^2);
p   = sqrt(x^2+y^2);
th  = atan2(a*z,b*p);
lon = atan2(y,x);
lat = atan((z+ep^2*b*(sin(th))^3)/(p-e^2*a*(cos(th))^3));
N   = a/sqrt(1-e^2*(sin(lat))^2);
alt = p/cos(lat)-N;

% correct for numerical instability in altitude near exact poles:
% (after this correction, error is about 2 millimeters, which is about
% the same as the numerical precision of the overall function)

k=abs(x)<1 & abs(y)<1;
alt(k) = abs(z(k))-b;
GPS=[lat,lon,alt];

return








