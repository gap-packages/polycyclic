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

#############################################################################
##
##  <#GAPDoc Label="Obsolete">
##  Over time, the interface of &Polycyclic; has changed. This
##  was done to get the names of &Polycyclic; functions to agree with the
##  general naming conventions used throughout GAP. Also, some &Polycyclic;
##  operations duplicated functionality that was already available in
##  the core of GAP under a different name. In these cases, whenever possible
##  we now install the &Polycyclic; code as methods for the existing GAP
##  operations instead of introducing new operations.
##  <P/>
##  For backward compatibility, we still provide the old, obsolete
##  names as aliases. However, please consider switching to the new names
##  as soon as possible. The old names may be completely removed at some
##  point in the future.
##  <P/>
##  The following function names were changed.
##  <P/>
##  <Index Key="SchurCovering"><C>SchurCovering</C></Index>
##  <Index Key="SchurMultPcpGroup"><C>SchurMultPcpGroup</C></Index>
##  <Table Align="l|l">
##  <Row>
##    <Item><E>OLD</E></Item>
##    <Item><E>NOW USE</E></Item>
##  </Row>
##  <HorLine/>
##  <Row>
##    <Item><C>SchurCovering</C></Item>
##    <Item><Ref Func="SchurCover"/></Item>
##  </Row>
##  <Row>
##    <Item><C>SchurMultPcpGroup</C></Item>
##    <Item><Ref Func="AbelianInvariantsMultiplier"/></Item>
##  </Row>
##  </Table>
##  <#/GAPDoc>

DeclareSynonymAttr("SchurCovering", SchurCover);

#DeclareSynonymAttr("SchurExtensionEpimorphism", EpimorphismSchurExtension);
#DeclareSynonymAttr("NonAbelianExteriorSquareEpimorphism", EpimorphismNonabelianExteriorSquare);
#DeclareSynonymAttr("NonAbelianExteriorSquare", NonabelianExteriorSquare);

# The following does not use DeclareSynonymAttr on purpose
SchurMultPcpGroup := AbelianInvariantsMultiplier;

