RSRC
 LVCCLBVW  �  4      |   p �              < � @�      ����            ��Y�zI�[�K:�         t� [��ZG��m�p0���ُ ��	���B~   , LVCCPmacEncoderCaptureControl.ctl          &    @Position Capture Control        �   ! 
 c  x    
 d   0   `    
 P       P        @ ����   @ ����  
 P   	 
 c     @flg @oRt @eof @P    udf @Position Capture Control  @dfd @txd @old @ext  P        
 c   $  
 c      �  
 c     
 c           `    > P                              
 d             0  
                0          J  Xx�c`�	�� in�� ��7i6�Z�P;0��Đe�� 5]�4�)�`b& ��
 �AVń� J��     , VIDSPmacEncoderCaptureControl.ctl          �   x��a``�4�0;�� ��)� �w��g�
x�;�Y�ݮ�zST8lA�J�w����?�0aB|\Tdt��	��9*��Aa��%**�5*������[~��T]�
�T�
�a�Tʰ#d���0���L�d�t�� i��d�Y�H�?02�0(3�bXİ
�/gW$o�� �(@r      �   8.2    \  XThis parameter determines which signal or combination of signals (and which polarity) triggers a position capture of the counter for encoder n.  If a flag input (home, limit, or fault) is used, I903 (etc.) determines which flag.  Proper setup of this variable is essential for a successful home search, which depends on the position-capture function.  The following settings may be used:

Setting	 Meaning
0	          Software Control
1	          Rising edge of CHCn (third channel)
2		         Rising edge of Flag n (as set by Flag Select)
3		         Rising edge of [CHCn AND Flag n]
4		         Software Control
5		         Falling edge of CHCn (third channel)
6		         Rising edge of Flag n (as set by Flag Select)
7		         Rising edge of [CHCn/ AND Flag n]
8		         Software Control
9		         Rising edge of CHCn (third channel)
10		       Falling edge of Flag n (as set by Flag Select)
11		       Rising edge of [CHCn AND Flag n/]
12		       Software Control
13		       Falling edge of CHCn (third channel)
14		       Falling edge of Flag n (as set by Flag Select)
15		       Rising edge of [CHCn/ AND Flag n/]

Note that several of these values are redundant.  To do a software-controlled position capture, preset this parameter to 0 or 4; when the parameter is then changed to 8 or 12, the capture is triggered (this is not of much practical use).

   ������  �  �  �  �� �  �  �����������Ȝ�  �  �  �  �� �  ��  ��<�� ���������(���ǼA�  �  �  �  ����   &    @Position Capture Control         (    @Position Capture Control         , FPHPPmacEncoderCaptureControl.ctl          d           F # W �   F   $   W   �     ���                            Position Capture Control   H           a3 rA   a  4   n  A     ���                              H          ]   n   ]   !   j                                     P           *  ;     *      ;                                          Pane    
�x��V�o�T�7m�c��v�ֈ��!�MX>��~	�tZ�R��44!׾I,9vd;-}������oH��@��@�2P���=����@l�9�\;I��hV�:������9��!�Oa�WC�8hPx+��<|� zq���>�� 9#~�ӕ��2�삸���b!� �*��2��2�$���0�_��	7f(�����c�qЄ��{�����F�������禧�UEHXi8���'4�n��400�,�����zN�HA2�<��Ivϫ:��VN�s�R����$���Pu�V��ƆE�4l�&���!��f�Դ����bd�`Mʰv�]Qg3@Mu�P�Y���PF��D�E��sF�F���U;�td��fG�.ZT����$	S[�G��3" }�4
�oQ�X� |�JeTԲ�n�)�#�(˰�)j���dʹh�U��+��X(�c�3E]f�y�3��[��el�o���M6��<ϯy���tx��Һ֌��%뢡ۦ����U��R%�&v���N���9'�:�"�D p��5�g@H�F6���5�Qَ��#?t]���np��ڌ�4O�m^�4�T�3/,��)��gOR=w<Ց�S��p���N�Z�S��ç*�}8&��p���<}��D�f~հ)t�d�&5�Lq�E��"t,äJQW$�f�c�`�؈1&{1jT�*QR0)Siw�3� I64��ui�][�`j�U��,���,�NMD���gf�M40
�.�O7lC��F�)A���t$��a�vhO`Ҿ��d�A��%�����.��W#��cl���s�k�raર�k�[����n(��.ïZ���C�d���o�y�8�Jo�F��/�����s��U�+����p��ks���^cU�aGƼ��W���z⺚���#].��'��qT]~O��'\W�1�#�����~R ��������.�u��~gU� ��o`x��4��XQ{E8�l���	 �;�s���_)UHop�����@�����$��	��>�����f����`\�����k��]B��N�̭���b����+s��jgOL�=�����ZAK\b-q��%�!L��h��������?]��ٖ���@7溜�~~,�
$�3cQ̻`���������g����|�;7Be�tE��P��l�d��؇e�Y��_�R��u?ͣf&�R*�c�Y������/�}�e�A���GK�2�R�ݹ�!R~          	�   , BDHPPmacEncoderCaptureControl.ctl          �   �x�c``�" ���/���W C�/����oN?��@�Q@����_�_��`�#�P��ƨb��r��A�#�$�aA�������1��8���r��l� "Ufɷ� s��H	 ��"�               =   (                                        �       �     
 �   �     
 �   �     
 �   ݀ � �  
 �                                                                                                                   ߀ � � -TahomaTahomaTahoma02   RSRC
 LVCCLBVW  �  4      |               4       LVSR      LIvi       CONP      4TM80      HDFDS      \LIds      pVICD      �vers      �STRG      �ICON      �CPC2      �DTHP      �LIfp      �TRec     FPHb      `FPSE      tLIbd      �BDHb      �BDSE      �MUID      �HIST      �FTAB      �    ����        4��    ����       t(��    ����       �8��    ����       �,��    ����      � ��    ����      ���    ����       ��   ����      ���    ����      ����    ����      	,��    ����      	����    ����      	ܰ��    ����      
���   ����      
8���   ����      
����   ����      
쀖�   ����      8t��    ����      �h��    ����      �\��    ����      �P��    ����      �D��    ����      T��    ����      `��    ����      hؕ�   �����      �̕�