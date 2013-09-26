#ifndef DETECTOR_H
#define DETECTOR_H

#include "smartbg_global.h"


const unsigned char MaskSkip    = 0x00;
const unsigned char MaskCheck   = 0xFF;

const unsigned char FeedbackKeep    = 0xFF;
const unsigned char FeedbackMerge   = 0x00;
const unsigned char FeedbackNone    = 0x7F;

const unsigned char ResultBackground    = 0x00;
const unsigned char ResultForeground    = 0xFF;

class SMARTBGSHARED_EXPORT Detector {
public:
    Detector(int width,
             int height,
             int mruSize,
             int colourDistance,
             int probabilityUpdate,
             int probabilityMerge);

    ~Detector();

    void setupBackground(const unsigned char *data);

    void setupMask(const unsigned char *data);

    void process(const unsigned char *frame,
                 const unsigned char *feedback);

    const unsigned char *getResult() const;

protected:

    int _Width;             //
    int _Height;            //
/*
    int _HGap;              //
    int _PxSize;            //
*/
    int _MRUSize;           // MRU List size for each pixel
    int _ColourDistance;    // maximal colour distance for background
    int _ProbabilityUpdate; // probability value for update background model
    int _ProbabilityMerge;  // probability value for insert pixetl to bground

};

#endif // DETECTOR_H
