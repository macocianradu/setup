Vim�UnDo� �)���(�q!l��O�k�էlM& i�U��@                          6       6   6   6    f�Ø    _�                             ����                                                                                                                                                                                                                                                                                                                                                             f��    �          
      !namespace Homefull.Core.Entities;5��                                                  5�_�                       '    ����                                                                                                                                                                                                                                                                                                                                                             f��     �          
      ~namespace Homefull.Core.Entities.Actual  1   namespace Homefull.Core.Entities.Actual;                                        ;5��        '       -           '       -               5�_�                       '    ����                                                                                                                                                                                                                                                                                                                                                             f��     �          
      Qnamespace Homefull.Core.Entities.Actual;                                        ;5��        '       *           '       *               5�_�                       '    ����                                                                                                                                                                                                                                                                                                                                                             f��    �          
      'namespace Homefull.Core.Entities.Actual5��        '                  '                      5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             f��     �         
      public class Document 5��                      	   @               	       5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             f��     �          
      (namespace Homefull.Core.Entities.Actual;5��                                           (       5�_�      	                     ����                                                                                                                                                                                                                                                                                                                                                             f��    �               public class Document : IEntity5��                      
   q               
       5�_�      
          	          ����                                                                                                                                                                                                                                                                                                                                                             f��    �               )public class Document : IEntity<Document>5��              
           q       
               5�_�   	              
           ����                                                                                                                                                                                                                                                                                                                                                             f�3�     �                   �             5��                          v                     �                      3   z              3       5�_�   
                    .    ����                                                                                                                                                                                                                                                                                                                                                             f�3�    �               7    public DateTime LastUpdate { get; set; } =default!;5��       .                  �                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             f�5�     �                   �             5��                          �                     �                      1   �              1       5�_�                       ,    ����                                                                                                                                                                                                                                                                                                                                                             f�5�     �               5    public string PropertyId { get; set; } =default!;5��       ,                  �                     5�_�                       ,    ����                                                                                                                                                                                                                                                                                                                                                             f�5�    �                   �             5��                          �                     �                         �                     �                         �                     �                         �                     �                         �                     �                        �                    �                        �                    �                        �                    �                         �                     �                        �                    �                        �                    �                        �                    �       *                                     5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             f�=�     �                   public override�                   �             5��                                               �                                               �                                              �                      	   "              	       �                         *                     �                        )                    �                        )                    �                     	   )             	       �                         1                     �                         0                     �                         /                     �                         .                     �                         -                     �                         ,                     �                         +                     �                         *                     �                        )                    �                         :                     �                        9                    �                        9                    �                        9                    �       -                  K                     �       -                 K                     �                      	   L             	       �                         L                    �                        Q                     �                      	   R             	       �                         R                    5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             f�=�     �             5��                          R                     �                         R                    �                          R                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             f�=�     �                5��                          R                     �                         ^                     �                        ]                    �                        ]                    �                        ]                    �                         k                     �                        j                    �       '                 y              	       �                         z                    �                        �                     �                         �                     5�_�                       '    ����                                                                                                                                                                                                                                                                                                                                                             f�=�     �               '        if(document is typeof(Document)5��       '                  y                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                V   '    f�=�     �                                {                   }5��                         {                    �                         �                    5�_�                           ����                                                                                                                                                                                                                                                                                                                                                V   '    f�=�     �             5��                          �              	       �                         �                    �                          �                     5�_�                           ����                                                                                                                                                                                                                                                                                                                                                V   '    f�=�     �               (        if(document is typeof(Document))5��                         e                     �                         i                     �                         h                     �                         g                     �                        f                    �                     	   f             	       5�_�                           ����                                                                                                                                                                                                                                                                                                                                                V   '    f�=�     �               2        if(document.GetType() is typeof(Document))5��                         p                     5�_�                           ����                                                                                                                                                                                                                                                                                                                                                V   '    f�=�     �               /        if(document.GetType() typeof(Document))5��                         p                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                V   '    f�=�     �                5��                          �                     5�_�                           ����                                                                                                                                                                                                                                                                                                                                                V   '    f�=�     �               2        if(document.GetType() == typeof(Document))5��                        p                    5�_�                           ����                                                                                                                                                                                                                                                                                                                                                V   '    f�=�     �               2        if(document.GetType() 1= typeof(Document))5��                        p                    5�_�                           ����                                                                                                                                                                                                                                                                                                                                                V   '    f�=�     �                       5��                         �                     �              	          �      	              �       &                  �                     �       %                  �                     �       $                  �                     �       #                 �                    �       #                  �                     �       "                  �                     �       !              .   �             .       5�_�                           ����                                                                                                                                                                                                                                                                                                                                                V   '    f�=�     �                       �             5��                          �              	       �                         �                     �                         �                     �                        �                    5�_�                       #    ����                                                                                                                                                                                                                                                                                                                                                V   '    f�=�     �               -    public void UpdateFrom(IEntity document) 5��       #                  A                     5�_�                       #    ����                                                                                                                                                                                                                                                                                                                                                V   '    f�=�     �               %    public void UpdateFrom(IEntity ) 5��       #                  A                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                V   '    f�=�     �               2        if(document.GetType() != typeof(Document))5��                         [                     5�_�      !                      ����                                                                                                                                                                                                                                                                                                                                                V   '    f�=�     �               *        if(.GetType() != typeof(Document))5��                         [                     5�_�       "           !          ����                                                                                                                                                                                                                                                                                                                                                V   '    f�>      �                       let doc = documen5��                         �                     5�_�   !   #           "          ����                                                                                                                                                                                                                                                                                                                                                V   '    f�>     �                       let = documen5��                      	   �              	       5�_�   "   $           #          ����                                                                                                                                                                                                                                                                                                                                                V   '    f�>     �                       let document = documen5��                                              �                                              �                                               �                         �                     �                         �                     �                         �                     �                        �                    �       $                  	                     �       #                                       �       "                                       �       !                                     �       !                                     �       !              	                	       5�_�   #   %           $          ����                                                                                                                                                                                                                                                                                                                                                V   '    f�>     �               *        let document = entity as Document;5��                         �                     5�_�   $   &           %          ����                                                                                                                                                                                                                                                                                                                                                V   '    f�>     �               &        document = entity as Document;5��                         �                     5�_�   %   '           &          ����                                                                                                                                                                                                                                                                                                                                                V   '    f�>     �                       this.PropertyId�                       this.Content�                       �             5��                                        	       �                                              �                                            �                     	                	       �                         %                     �                        $                    �                        $                    �                        $                    �                        -                    �       "                 2              	       �                         ;                     �                         A                     �                        @                    �                        @                    �                         K                     �                        J                    �                        J                    �                     
   J             
       �                         S                    �                         S                    �       (                 [              	       �                         d                     �                         j                     �                     
   i             
       �              
          i      
              �                         w                     �                        v                    �                        v                    �                        v                    �       $                  �                     �       #              
                
       �       #       
                
              5�_�   &   (           '      )    ����                                                                                                                                                                                                                                                                                                                                                V   '    f�>)     �             5��                                        	       �                                               5�_�   '   )           (      *    ����                                                                                                                                                                                                                                                                                                                                                V   '    f�>/     �               "            ?? throw new Exception�               *        var document = entity as Document;5��       )                                     �       ,                                       �       +                                       �       *                                       �       *                               	       �                                             �                     	   !             	       �                     	   )             	       �              	          )      	              �       4                  D                     �       3                 C                    �       G                  W                     �       F                 V                    �       G                  W                     �       F                 V                    5�_�   (   *           )      0    ����                                                                                                                                                                                                                                                                                                                                         0       V   S    f�>E    �                0        if(entity.GetType() != typeof(Document))   	        {   O            throw new Exception("Document can only be updated from document!");   	        }5��                          P      �               5�_�   )   +           *          ����                                                                                                                                                                                                                                                                                                                                                             f�W�    �               6    public Property Property { get; set; } = default!;5��                         �                     5�_�   *   ,           +          ����                                                                                                                                                                                                                                                                                                                                                             f�^e   	 �               public class Document : IEntity5��                         k                      5�_�   +   -           ,           ����                                                                                                                                                                                                                                                                                                                                                             f��{   
 �               {    �                   �             5��                          y                      �                          y                      �                          y                      �                         x                      5�_�   ,   .           -          ����                                                                                                                                                                                                                                                                                                                                                             f�rJ    �   
            2    public DateTime Date { get; set; } = default!;5��    
                     [                     5�_�   -   /           .   	        ����                                                                                                                                                                                                                                                                                                                                                             f��l     �   	                �   	          5��    	                                           �    	                                          �    	                    ,                    5�_�   .   0           /          ����                                                                                                                                                                                                                                                                                                                                                             f�Ã     �               .        this.PropertyId = document.PropertyId;5��                         d                     5�_�   /   1           0          ����                                                                                                                                                                                                                                                                                                                                                             f�Ä     �               *        .PropertyId = document.PropertyId;5��                         d                     5�_�   0   2           1          ����                                                                                                                                                                                                                                                                                                                                                             f�Ä     �               (        this.Content = document.Content;5��                         ;                     5�_�   1   3           2          ����                                                                                                                                                                                                                                                                                                                                                             f�Ä     �               $        .Content = document.Content;5��                         ;                     5�_�   2   4           3          ����                                                                                                                                                                                                                                                                                                                                                             f�Å     �               "        this.Name = document.Name;5��                                              5�_�   3   5           4          ����                                                                                                                                                                                                                                                                                                                                                             f�Å     �                       .Name = document.Name;5��                                              5�_�   4   6           5          ����                                                                                                                                                                                                                                                                                                                                                             f�Ë     �                       �             5��                          |              	       �                      	   �              	       �              	          �      	              �                        �                    �                        �                    �                        �                    5�_�   5               6      *    ����                                                                                                                                                                                                                                                                                                                                                             f�×    �               +    public void UpdateFrom(IEntity entity)        {�               *        var document = entity as Document    T            ?? throw new Exception("Document can only be updated from a document!");5��       )               �                    �       *               �                    5�_�              	         (    ����                                                                                                                                                                                                                                                                                                                                                             f��     �              5��                          ~       /               5��