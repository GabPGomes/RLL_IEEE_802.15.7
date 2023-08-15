# RLL_IEEE_802.15.7
Run Length Limited Encoder and Decoder for IEEE 802.15.7, implementing Manchester, 4B6B and 8B10B modes for PHY I, II & III.

The 8B10B Enc/Dec is a third party IP made by Ken Boyette, under GPL License. https://opencores.org/projects/8b10b_encdec

This project contains FIFOs and Shift Registers from Intel Quartus Prime IP Catalog, which can be used for free in Quartus Prime Lite.

All other files/IPs are under MIT License.

The core wasn't fully verified, so beware of some bugs.

The project was a Final Paper at UFMG's (Universidade Federal de Minas Gerais, Brasil) Electrical Engineering Undergraduate Course. It is part of a larger project aiming to develop a complete PHY layer for IEEE 802.15.7. The Foward Error Correction core is available at https://github.com/mateusgs/FEC_IEEE.802.15.7
