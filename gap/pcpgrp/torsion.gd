############################################################################
##
## Polycyclic: Computation with polycyclic groups
## Copyright (C) 1999-2012  Bettina Eick
## Copyright (C) 1999-2007  Werner Nickel
## Copyright (C) 2010-2012  Max Horn
##
## This program is free software; you can redistribute it and/or
## modify it under the terms of the GNU General Public License
## as published by the Free Software Foundation; either version 2
## of the License, or (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
##

DeclareAttribute( "TorsionSubgroup", IsGroup );
DeclareAttribute( "NormalTorsionSubgroup", IsGroup );
DeclareAttribute( "FiniteSubgroupClasses", IsGroup );
DeclareGlobalFunction( "RootSet" );


# TODO: declare IsTorsionFree for IsMagma or IsObject and not just IsGroup?
DeclareProperty( "IsTorsionFree", IsGroup );
InstallSubsetMaintenance( IsTorsionFree, IsGroup and IsTorsionFree, IsGroup );

InstallTrueMethod( IsTorsionFree, IsGroup and IsTrivial );
InstallTrueMethod( HasIsTorsionFree, IsGroup and IsFinite and IsNonTrivial );
InstallTrueMethod( IsTorsionFree, IsFreeGroup );

InstallIsomorphismMaintenance( IsTorsionFree, IsGroup and IsTorsionFree, IsGroup );

# TODO: declare IsFreeAbelian for IsMagma or IsObject and not just IsGroup?
DeclareProperty( "IsFreeAbelian", IsGroup );
InstallSubsetMaintenance( IsFreeAbelian, IsGroup and IsFreeAbelian, IsGroup );
InstallTrueMethod( IsFreeAbelian, IsGroup and IsTrivial );
InstallTrueMethod( HasIsFreeAbelian, IsGroup and IsFinite and IsNonTrivial );
InstallTrueMethod( IsFreeAbelian, IsFinitelyGeneratedGroup and IsTorsionFree and IsAbelian);

InstallIsomorphismMaintenance( IsFreeAbelian, IsGroup and IsFreeAbelian, IsGroup );


# free abelian groups are abelian and torsion free
InstallTrueMethod( IsAbelian, IsGroup and IsFreeAbelian );
InstallTrueMethod( IsTorsionFree, IsGroup and IsFreeAbelian );
