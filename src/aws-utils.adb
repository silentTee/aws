------------------------------------------------------------------------------
--                              Ada Web Server                              --
--                                                                          --
--                         Copyright (C) 2000-2001                          --
--                                ACT-Europe                                --
--                                                                          --
--  Authors: Dmitriy Anisimkov - Pascal Obry                                --
--                                                                          --
--  This library is free software; you can redistribute it and/or modify    --
--  it under the terms of the GNU General Public License as published by    --
--  the Free Software Foundation; either version 2 of the License, or (at   --
--  your option) any later version.                                         --
--                                                                          --
--  This library is distributed in the hope that it will be useful, but     --
--  WITHOUT ANY WARRANTY; without even the implied warranty of              --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU       --
--  General Public License for more details.                                --
--                                                                          --
--  You should have received a copy of the GNU General Public License       --
--  along with this library; if not, write to the Free Software Foundation, --
--  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.          --
--                                                                          --
--  As a special exception, if other files instantiate generics from this   --
--  unit, or you link this unit with other files to produce an executable,  --
--  this  unit  does not  by itself cause  the resulting executable to be   --
--  covered by the GNU General Public License. This exception does not      --
--  however invalidate any other reasons why the executable file  might be  --
--  covered by the  GNU Public License.                                     --
------------------------------------------------------------------------------

--  $Id$

with Ada.Integer_Text_IO;
with Ada.Strings.Fixed;

with Interfaces.C.Strings;

with Sockets.Thin;

package body AWS.Utils is

   -----------------
   -- Gethostname --
   -----------------

   function Gethostname return String is

      use Interfaces;

      Buffer : aliased C.char_array := (1 .. 100 => ' ');
      Name   : C.Strings.chars_ptr :=
        C.Strings.To_Chars_Ptr (Buffer'Unchecked_Access);
      Len    : C.int := Buffer'Length;
      Res    : C.int;

   begin
      Res := Sockets.Thin.C_Gethostname (Name, Len);
      return C.Strings.Value (Name, C.size_t (Len));
   end Gethostname;

   ---------
   -- Hex --
   ---------

   function Hex (V : in Natural) return String is
      use Ada.Strings;

      Hex_V : String (1 .. 8);
   begin
      Ada.Integer_Text_IO.Put (Hex_V, V, 16);
      return Hex_V (Fixed.Index (Hex_V, "#") + 1 ..
                    Fixed.Index (Hex_V, "#", Backward) - 1);
   end Hex;

   -----------
   -- Image --
   -----------

   function Image (N : in Natural) return String is
      N_Img : constant String := Natural'Image (N);
   begin
      return N_Img (N_Img'First + 1 .. N_Img'Last);
   end Image;

   -----------
   -- Image --
   -----------

   function Image (D : in Duration) return String is
      D_Img : constant String := Duration'Image (D);
      K     : constant Natural := Ada.Strings.Fixed.Index (D_Img, ".");
   begin
      if K = 0 then
         return D_Img (D_Img'First + 1 .. D_Img'Last);
      else
         return D_Img (D_Img'First + 1 .. K + 2);
      end if;
   end Image;

end AWS.Utils;
