C=================================================================
#include "fintrf.h"
#if 0
C     
C     mxgetepsf.F
C     .F file needs to be preprocessed to generate .for equivalent
C     
#endif
C     mxgetepsf.f 
C
C     This is an example of how to use mxGetEps.  The function takes two
C     real double arrays and does an element-by-element compare of each
C     element for equality within eps. Eps is the distance from 1.0 to
C     the next largest floating point number and is used as the default
C     tolerance.  If all the elements are equal within eps, a 1 is returned.
C     If they are not all equal within eps, a 0 is returned.
C
C     This is a MEX-file for MATLAB.  
C     Copyright 1984-2018 The MathWorks, Inc.
C     All rights reserved.
C     
C=================================================================

      subroutine mexFunction(nlhs, plhs, nrhs, prhs)

C     Declarations
      implicit none

      mwPointer plhs(*), prhs(*)
      integer nlhs, nrhs
      mwPointer mxCreateDoubleMatrix
	  
#if MX_HAS_INTERLEAVED_COMPLEX
	  mwPointer mxGetDoubles
#else
	  mwPointer mxGetPr
#endif

      mwPointer first_ptr, second_ptr
      mwPointer mxGetM, mxGetN
      mwSize  mxGetNumberOfElements
      integer mxIsDouble, mxIsComplex
      real*8  mxGetEps

      mwSize c, j, elements, rc
      real*8 first(10000), second(10000), eps, TRUE
      data TRUE /1.0/
    
C     Check for proper number of input and output arguments    
      if (nrhs .ne. 2) then
	    call mexErrMsgIdAndTxt( 
     +       'MATLAB:mxgetepsf:invalidNumInputs',
     +       'Two input arguments required.')
      end if
      if (nlhs .gt. 1) then
        call mexErrMsgIdAndTxt( 'MATLAB:mxgetepsf:maxlhs', 
     +       'Too many output arguments.')
      end if
    
C     Check data type of first input argument
      if ((mxIsDouble(prhs(1)) .ne. 1) .or.
     +    (mxIsDouble(prhs(2)) .ne. 1) .or.
     +    (mxIsComplex(prhs(1)).ne. 0) .or.
     +    (mxIsComplex(prhs(2)).ne. 0)) then
        call mexErrMsgIdAndTxt( 
     +      'MATLAB:mxgetepsf:inputNotRealDouble', 
     +      'Input arguments must be real of type double.')
      end if
    
C     Check that dimensions are the same for input arguments.
      if ( mxGetM(prhs(1)) .ne. mxGetM(prhs(2))) then
        call mexErrMsgIdAndTxt(
     +   'MATLAB:mxgetepsf:numDimensionsMismatch', 
     +   'Inputs must have the same number of rows.')
      end if
      if ( mxGetN(prhs(1)) .ne. mxGetN(prhs(2))) then
        call mexErrMsgIdAndTxt( 
     +   'MATLAB:mxgetepsf:numelementMismatch', 
     +   'Inputs must have the same number of elements.')
      end if

C     Get the number of elements in the input argument
      elements = mxGetNumberOfElements(prhs(1))
	  
C     Get the input values 
#if MX_HAS_INTERLEAVED_COMPLEX
      first_ptr = mxGetDoubles(prhs(1))
      second_ptr = mxGetDoubles(prhs(2))
#else
      first_ptr = mxGetPr(prhs(1))
      second_ptr = mxGetPr(prhs(2))
#endif

      call mxCopyPtrToReal8(first_ptr, first, elements) 
      call mxCopyPtrToReal8(second_ptr, second, elements)
    
C     Create output 
      rc = 1
      plhs(1)=mxCreateDoubleMatrix(rc,rc,0)
    
C     Get the value of eps 
      eps = mxGetEps()

C     Check for equality within eps 
      do 20 j=1,elements
    	 if ((abs(first(j) - second(j))).gt.(abs(second(j)*eps))) then
	      call mexWarnMsgIdAndTxt(
     +     'MATLAB:mxgetepsf:NotEqual',
     +     'Inputs are not the same within eps.')
    	    go to 21
	     end if
   20 continue

   21 if (j .gt. elements ) then
#if MX_HAS_INTERLEAVED_COMPLEX
	    call mxCopyReal8ToPtr(TRUE,mxGetDoubles(plhs(1)),1)		
#else
	    call mxCopyReal8ToPtr(TRUE,mxGetPr(plhs(1)),1)
#endif
      end if

      return
      end
