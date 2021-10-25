// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//      Name:       catbios.h
//      Purpose:    Cohverted catbios.h as couldn't hack the original code, damn strings screwed it up.
//      Created:    25th October 2021
//      Author:     Bernardo Kastrup
//                  Paul Robson (paul@robsons.org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

#define byte BYTE8

#define PS2_ENTER       13
#define PS2_ESC         (GFXKEY_ESCAPE+1000)
#define PS2_PAGEUP      (GFXKEY_PAGEUP+1000)
#define PS2_PAGEDOWN    (GFXKEY_PAGEDOWN+1000)
#define PS2_UPARROW     (GFXKEY_UP+1000)
#define PS2_RIGHTARROW  (GFXKEY_RIGHT+1000)
#define PS2_LEFTARROW   (GFXKEY_LEFT+1000)
#define PS2_DOWNARROW   (GFXKEY_DOWN+1000)
#define PS2_DELETE      8

static void enter();
static char *getNextWord(bool fromTheBeginning);
static void help();
static void list(char *address);
static void runCode();
static void resetCPUs();
static void load(char *filename, char *address, bool silent);
static void save(char *startAddr, char *endAddr, char *filename);
static void dir();
static void delFile(char *filename);
static byte cpeek(unsigned int address);
static void cpoke(unsigned int address, byte data);
static unsigned int addressTranslate(unsigned int virtualAddress);
static void cprintChar(byte x, byte y, byte token);
static void testMem();
static void playJingle();
static void cls();
static void ccls();
static void cprintFrames();
static void cprintString(byte x, byte y, char *text);
static void cprintChar(byte x, byte y, byte token);
static void cprintEditLine();
static void clearEditLine();
static void cprintStatus(byte status);
static void help();
static void updateProcessorState();

static const BYTE8 default_font[2048] = {
    #include "_char_data.h"
};

static const BYTE8 cerberus_image[] = {
    #include "_img_data.h"
};

#define delay(a)        {}
#define tone(PIN,pitch,len) {}

char editLine[40] ;
char previousEditLine[40];

#define F(s)        ((char *)(s))

int pos = 1;                           /** Position in edit line currently occupied by cursor **/
bool mode = false;                     /** false = 6502 mode, true = Z80 mode **/
bool cpurunning = false;               /** true = CPU is running, CAT should not use the buses **/
bool fast = false;                     /** true = 8 MHz CPU clock, false = 4 MHz CPU clock **/

static void catbios_setup() {    
    mode = true;
    resetCPUs();
    for (int i = 0;i < 0x800;i++) cpoke(0xF000+i,default_font[i]);
    ccls();
    cprintFrames();
    clearEditLine();
    strcpy(previousEditLine,editLine);

    int p = 0;
    for (byte y = 2; y <= 25; y++) {
        for (byte x = 2; x <= 39; x++) {
            cprintChar(x, y, cerberus_image[p++]);
        }
    }
    cprintStatus(1);
    /** Play a little jingle while keyboard finishes initializing ... no don't **/
    // playJingle();
    // delay(1000);
    cprintStatus(0);
    cprintEditLine();
}

static void catbios_sync() {
    int ascii; /** Stores ascii value of key pressed **/
    byte i; /** Just a counter **/
    /** Wait for a key to be pressed, then take it from there... **/
    if (pendingKey) {
            ascii = pendingKey;                                             /** Read key pressed **/
            pendingKey = 0;
    //      tone(SOUND, 750, 5);                                            /** Clicking sound for auditive feedback to key presses **/
            if (!cpurunning) cprintStatus(0);                               /** Update status bar **/
            switch(ascii) {
                case PS2_ENTER:
                    if (!cpurunning) enter();
                    break;

                case PS2_ESC:
                    if (cpurunning) {
                        CPUReset();                    
                        ccls();
                        cprintFrames(); 
                        cprintStatus(0); 
                        clearEditLine(); 
                    }
                    break;

                case PS2_PAGEDOWN:
                case PS2_PAGEUP:
                case PS2_RIGHTARROW:
                    break;

                case PS2_UPARROW:
                    if (!cpurunning) {
                        for (i = 0; i < 38; i++) editLine[i] = previousEditLine[i];
                        i = 0;
                        while (editLine[i] != 0) i++;
                        pos = i;
                        cprintEditLine();
                    }
                    break;

                case PS2_DOWNARROW:
                    if (!cpurunning) clearEditLine();
                    break;

                case PS2_LEFTARROW:
                case PS2_DELETE:
                    if (!cpurunning) {
                        editLine[pos] = 32; /** Put an empty space in current cursor position **/
                        if (pos > 1) pos--; /** Update cursor position, unless reached left-most position already **/
                        editLine[pos] = 0; /** Put cursor on updated position **/
                        cprintEditLine(); /** Print the updated edit line **/
                    }
                    break;

                default:
                    if (!cpurunning) {
                        /** If a CPU is not running... **/
                        editLine[pos] = ascii; /** Put new character in current cursor position **/
                        if (pos < 37) pos++; /** Update cursor position **/
                        editLine[pos] = 0; /** Place cursor to the right of new character **/
                        cprintEditLine(); /** Print the updated edit line **/
                    } else {
                        /** Now, if a CPU is running... **/
                        cpoke(0x0201, ascii); /** Put token code of pressed key in the CPU's mailbox, at 0x0201 **/
                        cpoke(0x0200, 0x01); /** Flag that there is new mail for the CPU waiting at the mailbox **/
                        CPUInterrupt();
                    }
                    break;
                }
        }
}

/************************************************************************************************/
static void enter() {
    // /** Called when the user presses ENTER, unless a CPU program is being executed **/
    // /************************************************************************************************/
    // unsigned int addr; /** Memory addresses **/
    // byte data; /** A byte to be stored in memory **/
    // byte i; /** Just a counter **/
    // char *nextWord, nextNextWord, nextNextNextWord; /** General-purpose strings **/
    // nextWord = getNextWord(true); /** Get the first word in the edit line **/
    // nextWord.toLowerCase(); /** Ignore capitals **/
    // /** MANUAL ENTRY OF OPCODES AND DATA INTO MEMORY *******************************************/
    // if ((nextWord.charAt(0) == '0') && (nextWord.charAt(1) == 'x')) {
    //     /** The user is entering data into memory **/
    //     nextWord.remove(0, 2); /** Removes the "0x" at the beginning of the char *to keep only a HEX number **/
    //     addr = strtol(nextWord.c_str(), NULL, 16); /** Converts to HEX number type **/
    //     nextNextWord = getNextWord(false); /** Get next byte **/
    //     while (nextNextWord != "") {
    //         /** For as long as user has typed in a byte, store it **/
    //         data = strtol(nextNextWord.c_str(), NULL, 16); /** Converts to HEX number type **/
    //         cpoke(addr, data);
    //         addr++;
    //         nextNextWord = getNextWord(false); /** Get next byte **/
    //     }
    //     cprintStatus(2);
    //     /** LIST ***********************************************************************************/
    // } else if (nextWord == F("list")) {
    //     /** Lists contents of memory in compact format **/
    //     cls();
    //     nextWord = getNextWord(false); /** Get address **/
    //     list(nextWord);
    //     cprintStatus(2);
    //     /** CLS ************************************************************************************/
    // } else if (nextWord == F("cls")) {
    //     /** Clear the main window **/
    //     cls();
    //     cprintStatus(2);
    //     /** TESTMEM ********************************************************************************/
    // } else if (nextWord == F("testmem")) {
    //     /** Checks whether all four memories can be written to and read from **/
    //     cls();
    //     testMem();
    //     cprintStatus(2);
    //     /** 6502 ***********************************************************************************/
    // } else if (nextWord == F("6502")) {
    //     /** Switches to 6502 mode **/
    //     mode = false;
    //     digitalWrite(CPUSLC, LOW); /** Tell CAT of the new mode **/
    //     cprintStatus(2);
    //     /** Z80 ***********************************************************************************/
    // } else if (nextWord == F("z80")) {
    //     /** Switches to Z80 mode **/
    //     mode = true;
    //     digitalWrite(CPUSLC, HIGH); /** Tell CAT of the new mode **/
    //     cprintStatus(2);
    //     /** RESET *********************************************************************************/
    // } else if (nextWord == F("reset")) {
    //     resetFunc(); /** This resets CAT and, therefore, the CPUs too **/
    //     /** FAST **********************************************************************************/
    // } else if (nextWord == F("fast")) {
    //     /** Sets CPU clock at 8 MHz **/
    //     digitalWrite(CPUSPD, HIGH);
    //     fast = true;
    //     cprintStatus(2);
    //     /** SLOW **********************************************************************************/
    // } else if (nextWord == F("slow")) {
    //     /** Sets CPU clock at 4 MHz **/
    //     digitalWrite(CPUSPD, LOW);
    //     fast = false;
    //     cprintStatus(2);
    //     /** DIR ***********************************************************************************/
    // } else if (nextWord == F("dir")) {
    //     /** Lists files on uSD card **/
    //     dir();
    //     /** DEL ***********************************************************************************/
    // } else if (nextWord == F("del")) {
    //     /** Deletes a file on uSD card **/
    //     nextWord = getNextWord(false);
    //     delFile(nextWord);
    //     /** LOAD **********************************************************************************/
    // } else if (nextWord == F("load")) {
    //     /** Loads a binary file into memory, at specified location **/
    //     nextWord = getNextWord(false); /** Get the file name from the edit line **/
    //     nextNextWord = getNextWord(false); /** Get memory address **/
    //     load(nextWord, nextNextWord, false);
    //     /** RUN ***********************************************************************************/
    // } else if (nextWord == F("run")) {
    //     /** Runs the code in memory **/
    //     for (i = 0; i < 38; i++) previousEditLine[i] = editLine[i]; /** Store edit line just executed **/
    //     runCode();
    //     /** SAVE **********************************************************************************/
    // } else if (nextWord == F("save")) {
    //     nextWord = getNextWord(false); /** Get start address **/
    //     nextNextWord = getNextWord(false);
    //     nextNextNextWord = getNextWord(false);
    //     save(nextWord, nextNextWord, nextNextNextWord);
    //     /** MOVE **********************************************************************************/
    // } else if (nextWord == F("move")) {
    //     nextWord = getNextWord(false);
    //     nextNextWord = getNextWord(false);
    //     nextNextNextWord = getNextWord(false);
    //     binMove(nextWord, nextNextWord, nextNextNextWord);
    //     /** HELP **********************************************************************************/
    // } else if ((nextWord == F("help")) || (nextWord == F("?"))) {
    //     help();
    //     cprintStatus(10);
    //     /** ALL OTHER CASES ***********************************************************************/
    // } else cprintStatus(3);
    // if (!cpurunning) {
    //     for (i = 0; i < 38; i++) previousEditLine[i] = editLine[i]; /** Store edit line just executed **/
    //     clearEditLine(); /** Reset edit line **/
    //}
}

static char *getNextWord(bool fromTheBeginning) {
    // /** A very simple parser that returns the next word in the edit line **/
    // static byte initialPosition; /** Start parsing from this point in the edit line **/
    // byte i, j, k; /** General-purpose indices **/
    // if (fromTheBeginning) initialPosition = 1; /** Starting from the beginning of the edit line **/
    // i = initialPosition; /** Otherwise, continuing on from where we left off in previous call **/
    // while ((editLine[i] == 32) || (editLine[i] == 44)) i++; /** Ignore leading spaces or commas **/
    // j = i + 1; * Now start indexing the next word proper *
    // /** Find the end of the word, marked either by a space, a comma or the cursor **/
    // while ((editLine[j] != 32) && (editLine[j] != 44) && (editLine[j] != 0)) j++;
    // char nextWord[j - i + 1]; /** Create a buffer (the +1 is to make space for null-termination) **/
    // for (k = i; k < j; k++) nextWord[k - i] = editLine[k]; /** Transfer the word to the buffer **/
    // nextWord[j - i] = 0; /** Null-termination **/
    // initialPosition = j; /** Next time round, start from here, unless... **/
    // return (nextWord); /** Return the contents of the buffer **/
    return NULL;
}

static void help() {
    cls();
    cprintString(3, 2, F("The Byte Attic's CERBERUS 2080 (tm)"));
    cprintString(3, 3, F("        AVAILABLE COMMANDS:"));
    cprintString(3, 4, F(" (All numbers must be hexadecimal)"));
    cprintString(3, 6, F("0xADDR BYTE: Writes BYTE at ADDR"));
    cprintString(3, 7, F("list ADDR: Lists memory from ADDR"));
    cprintString(3, 8, F("cls: Clears the screen"));
    cprintString(3, 9, F("testmem: Reads/writes to memories"));
    cprintString(3, 10, F("6502: Switches to 6502 CPU mode"));
    cprintString(3, 11, F("z80: Switches to Z80 CPU mode"));
    cprintString(3, 12, F("fast: Switches to 8MHz mode"));
    cprintString(3, 13, F("slow: Switches to 4MHz mode"));
    cprintString(3, 14, F("reset: Resets the system"));
    cprintString(3, 15, F("dir: Lists files on uSD card"));
    cprintString(3, 16, F("del FILE: Deletes FILE"));
    cprintString(3, 17, F("load FILE ADDR: Loads FILE at ADDR"));
    cprintString(3, 18, F("save ADDR1 ADDR2 FILE: Saves memory"));
    cprintString(5, 19, F("from ADDR1 to ADDR2 to FILE"));
    cprintString(3, 20, F("run: Executes code in memory"));
    cprintString(3, 21, F("move ADDR1 ADDR2 ADDR3: Moves bytes"));
    cprintString(5, 22, F("between ADDR1 & ADDR2 to ADDR3 on"));
    cprintString(3, 23, F("help / ?: Shows this help screen"));
    cprintString(3, 24, F("ESC key: Quits CPU program"));
}

void binMove(char *startAddr, char *endAddr, char *destAddr) {
    // unsigned int start, finish, destination; /** Memory addresses **/
    // unsigned int i; /** Address counter **/
    // if (startAddr == "") cprintStatus(6); /** Missing the file's name **/
    // else {
    //     start = strtol(startAddr.c_str(), NULL, 16); /** Convert hexadecimal address char *to unsigned int **/
    //     if (endAddr == "") cprintStatus(6); /** Missing the file's name **/
    //     else {
    //         finish = strtol(endAddr.c_str(), NULL, 16); /** Convert hexadecimal address char *to unsigned int **/
    //         if (destAddr == "") cprintStatus(6); /** Missing the file's name **/
    //         else {
    //             destination = strtol(destAddr.c_str(), NULL, 16); /** Convert hexadecimal address char *to unsigned int **/
    //             if (finish < start) cprintStatus(9); /** Invalid address range **/
    //             else if ((destination <= finish) && (destination >= start)) cprintStatus(9); /** Destination cannot be within original range **/
    //             else {
    //                 for (i = start; i <= finish; i++) {
    //                     cpoke(destination, cpeek(i));
    //                     destination++;
    //                 }
    //                 cprintStatus(2);
    //             }
    //         }
    //     }
    // }
}

static void list(char *address) {
    // /** Lists the contents of memory from the given address, in a compact format **/
    // byte i, j; /** Just counters **/
    // unsigned int addr; /** Memory address **/
    // if (address == "") addr = 0;
    // else addr = strtol(address.c_str(), NULL, 16); * Convert hexadecimal address char *to unsigned int *
    // for (i = 2; i < 25; i++) {
    //     cprintString(3, i, "0x");
    //     cprintString(5, i, String(addr, HEX));
    //     for (j = 0; j < 8; j++) {
    //         cprintString(12 + (j * 3), i, String(cpeek(addr++), HEX)); /** Print bytes in HEX **/
    //     }
    // }
}

static void runCode() {
    // ccls();
    // /** REMEMBER:                           **/
    // /** Byte at 0x0200 is the new mail flag **/
    // /** Byte at 0x0201 is the mail box      **/
    // cpoke(0x0200, 0x00); /** Reset mail flag **/
    // cpoke(0x0201, 0x00); /** Reset mailbox **/
    // if (!mode) {
    //     /** We are in 6502 mode **/
    //     /** Non-maskable interrupt vector points to 0xFCB0, just after video area **/
    //     cpoke(0xFFFA, 0xB0);
    //     cpoke(0xFFFB, 0xFC);
    //     /** The interrupt service routine simply returns **/
    //     // FCB0        RTI             40
    //     cpoke(0xFCB0, 0x40);
    //     /** Set reset vector to 0x0202, the beginning of the code area **/
    //     cpoke(0xFFFC, 0x02);
    //     cpoke(0xFFFD, 0x02);
        // } else {
    //     /** We are in Z80 mode **/
    //     /** The NMI service routine of the Z80 is at 0x0066 **/
    //     /** It simply returns **/
    //     // 0066   ED 45                  RETN 
    //     cpoke(0x0066, 0xED);
    //     cpoke(0x0067, 0x45);
    //     /** The Z80 fetches the first instruction from 0x0000, so put a jump to the code area there **/
    //     // 0000   C3 00 01               JP   $0202
    //     cpoke(0x0000, 0xC3);
    //     cpoke(0x0001, 0x02);
    //     cpoke(0x0002, 0x02);
    // }
    // cpurunning = true;
    // digitalWrite(CPURST, HIGH); /** Reset the CPU **/
    // digitalWrite(CPUGO, HIGH); /** Enable CPU buses and clock **/
    // delay(50);
    // digitalWrite(CPURST, LOW); /** CPU should now initialize and then go to its reset vector **/
}

static void dir() {
//     /** Lists the files in the root directory of uSD card, if available **/
//     byte y = 2; /** Screen line **/
//     byte x = 0; /** Screen column **/
//     File root; /** Root directory of uSD card **/
//     File entry; /** A file on the uSD card **/
//     cls();
//     root = SD.open("/"); /** Go to the root directory of uSD card **/
//     while (true) {
//         entry = root.openNextFile(); /** Open next file **/
//         if (!entry) {
//             /** No more files on the uSD card **/
//             root.close(); /** Close root directory **/
//             cprintStatus(2); /** Announce completion **/
//             break; /** Get out of this otherwise infinite while() loop **/
//         }
//         cprintString(3, y, entry.name());
//         cprintString(20, y, String(entry.size(), DEC));
//         entry.close(); /** Close file as soon as it is no longer needed **/
//         if (y < 24) y++; * Go to the next screen line *
//         else {
//             cprintStatus(7); /** End of screen has been reached, needs to scrow down **/
//             for (x = 2; x < 40; x++) cprintChar(x, 29, ' '); /** Hide editline while waiting for key press **/
//             while (!keyboard.available()); /** Wait for a key to be pressed **/
//             if (keyboard.read() == PS2_ESC) {
//                 /** If the user pressed ESC, break and exit **/
//                 tone(SOUND, 750, 5); /** Clicking sound for auditive feedback to key press **/
//                 root.close(); /** Close the directory before exiting **/
//                 cprintStatus(2);
//                 break;
//             } else {
//                 tone(SOUND, 750, 5); /** Clicking sound for auditive feedback to key press **/
//                 cls(); /** Clear the screen and... **/
//                 y = 2; /** ...go back tot he top of the screen **/
//             }
//         }
//     }
}


static void cprintEditLine() {
    byte i;
    for (i = 0; i < 38; i++) cprintChar(i + 2, 29, editLine[i]);
}

static void clearEditLine() {
    /** Resets the contents of edit line and reprints it **/
    byte i;
    editLine[0] = 62;
    editLine[1] = 0;
    for (i = 2; i < 38; i++) editLine[i] = 32;
    pos = 1;
    cprintEditLine();
}

static void cprintStatus(byte status) {
    switch (status) {
        /** REMEMBER: The macro "F()" simply tells the compiler to put the char *in code memory, so to save dynamic memory **/
    case 1:
        cprintString(2, 27, F("        Here we go! Hang on...        "));
        break;
    case 2:
        cprintString(2, 27, F("            Alright, done!            "));
        break;
    case 3:
        cprintString(2, 27, F("      Darn, unrecognized command      "));
        tone(SOUND, 50, 150);
        break;
    case 4:
        cprintString(2, 27, F("   Oops, file doesn't seem to exist   "));
        tone(SOUND, 50, 150);
        break;
    case 5:
        cprintString(2, 27, F("     Oops, couldn't open the file     "));
        tone(SOUND, 50, 150);
        break;
    case 6:
        cprintString(2, 27, F("      Oops, missing an operand!!      "));
        tone(SOUND, 50, 150);
        break;
    case 7:
        cprintString(2, 27, F("  Press a key to scroll, ESC to stop  "));
        break;
    case 8:
        cprintString(2, 27, F("       The file already exists!       "));
        break;
    case 9:
        cprintString(2, 27, F("     Oops, invalid address range!     "));
        break;
    case 10:
        cprintString(2, 27, F("   Feel the power of Dutch design!!   "));
        break;
    default:
        cprintString(2, 27, F("      CERBERUS 2080: "));
        if (mode) cprintString(23, 27, F(" Z80, "));
        else cprintString(23, 27, F("6502, "));
        if (fast) cprintString(29, 27, F("8 MHz"));
        else cprintString(29, 27, F("4 MHz"));
        cprintString(34, 27, F("     "));
        break;
    }
}

static void playJingle() {
    delay(500); /** Wait for possible preceding keyboard click to end **/
    tone(SOUND, 261, 50);
    delay(150);
    tone(SOUND, 277, 50);
    delay(150);
    tone(SOUND, 261, 50);
    delay(150);
    tone(SOUND, 349, 500);
    delay(250);
    tone(SOUND, 261, 50);
    delay(150);
    tone(SOUND, 349, 900);
}

static void cls() {
    /** This clears the screen only WITHIN the main frame **/
    unsigned int x;
    unsigned int y;
    for (y = 2; y <= 25; y++)
        for (x = 2; x <= 39; x++)
            cprintChar(x, y, 32);
}

static void ccls() {
    /** This clears the entire screen **/
    unsigned int x;
    for (x = 0; x < 1200; x++)
        cpoke(0xF800 + x, 32); /** Video memory addresses start at 0XF800 **/
}

static void cprintFrames() {
    unsigned int x;
    unsigned int y;
    /** First print horizontal bars **/
    for (x = 2; x <= 39; x++) {
        cprintChar(x, 1, 3);
        cprintChar(x, 30, 131);
        cprintChar(x, 26, 3);
    }
    /** Now print vertical bars **/
    for (y = 1; y <= 30; y++) {
        cprintChar(1, y, 133);
        cprintChar(40, y, 5);
    }
}

static void cprintString(byte x, byte y, char *text) {
    unsigned int i = 0;
    while (text[i] != 0) {
        cprintChar(x+i,y,text[i]);i++;
    }   
}

static void cprintChar(byte x, byte y, byte token) {
    /** First, calculate address **/
    unsigned int address = 0xF800 + ((y - 1) * 40) + (x - 1); /** Video memory addresses start at 0XF800 **/
    cpoke(address, token);
}

static void testMem() {
    /** Tests that all four memories are accessible for reading and writing **/
    unsigned int x;
    byte i = 0;
    for (x = 0; x < 874; x++) {
        cpoke(x, i); /** Write to low memory **/
        cpoke(0x8000 + x, cpeek(x)); /** Read from low memory and write to high memory **/
        cpoke(addressTranslate(0xF800 + x), cpeek(0x8000 + x)); /** Read from high mem, write to VMEM, read from character mem **/
        if (i < 255) i++;
        else i = 0;
    }
}

static unsigned int addressTranslate(unsigned int virtualAddress) {
    byte numberVirtualRows;
    numberVirtualRows = (virtualAddress - 0xF800) / 38;
    return ((virtualAddress + 43) + (2 * (numberVirtualRows - 1)));
}

static void cpoke(unsigned int address, byte data) {
    CPUWriteMemory(address,data);
}

static byte cpeek(unsigned int address) {
    return CPUReadMemory(address);
}


static void delFile(char *filename) {
    // /** Deletes a file from the uSD card **/
    // if (!SD.exists(filename)) cprintStatus(4); * The file doesn't exist, so stop with error *
    // else {
    //     SD.remove(filename); /** Delete the file **/
    //     cprintStatus(2);
    //}
}

static void save(char *startAddr, char *endAddr, char *filename) {
    // /** Saves contents of a region of memory to a file on uSD card **/
    // unsigned int start, finish;
    // unsigned int i; /** Memory address counter **/
    // byte data; /** Data from memory **/
    // File dataFile; /** File to be created and written to **/
    // if (startAddr == "") cprintStatus(6); /** Missing operand **/
    // else {
    //     start = strtol(startAddr.c_str(), NULL, 16); /** Convert to hexadecimal number **/
    //     if (endAddr == "") cprintStatus(6); /** Missing operand **/
    //     else {
    //         finish = strtol(endAddr.c_str(), NULL, 16); /** Convert to hexadecimal number **/
    //         if (finish < start) cprintStatus(9); /** Invalid address range **/
    //         else {
    //             if (filename == "") cprintStatus(6); /** Missing the file's name **/
    //             else {
    //                 if (SD.exists(filename)) cprintStatus(8); /** The file already exists, so stop with error **/
    //                 else {
    //                     dataFile = SD.open(filename, FILE_WRITE); /** Try to create the file **/
    //                     if (!dataFile) cprintStatus(5); /** Cannot create the file **/
    //                     else {
    //                         /** Now we can finally write into the created file **/
    //                         for (i = start; i <= finish; i++) {
    //                             data = cpeek(i);
    //                             dataFile.write(data);
    //                         }
    //                         dataFile.close();
    //                         cprintStatus(2);
    //                     }
    //                 }
    //             }
    //         }
    //     }
    // }
}

static void load(char *filename, char *address, bool silent) {
    // /** Loads a binary file from the uSD card into memory **/
    // File dataFile; /** File for reading from on SD Card, if present **/
    // unsigned int addr; /** Address where to load the file into memory **/
    // if (filename == "") {
    //     if (!silent) cprintStatus(6);
    // } /** Missing file name, so stop **/
    // else {
    //     if (address == "") addr = 0x0202; /** If not otherwise specified, load file into start of code area **/
    //     else addr = strtol(address.c_str(), NULL, 16); /** Convert address char *to hexadecimal number **/
    //     if (!SD.exists(filename)) {
    //         if (!silent) cprintStatus(4);
    //     } /** The file does not exist, so stop with error **/
    //     else {
    //         dataFile = SD.open(filename); /** Open the binary file **/
    //         if (!dataFile) cprintStatus(5); /** Cannot open the file **/
    //         else {
    //             while (dataFile.available()) {
    //                 /** While there is data to be read... **/
    //                 cpoke(addr, dataFile.read()); /** Read data from file and store it in memory **/
    //                 addr++; /** Increment address **/
    //                 if (addr == 0) {
    //                     /** Break if address wraps around to the start of memory **/
    //                     dataFile.close();
    //                     break;
    //                 }
    //             }
    //             dataFile.close();
    //             if (!silent) cprintStatus(2);
    //         }
    //     }
    // }
}

static void resetCPUs() {
    cpurunning = false;                     // Stop CPU
    CPUSetZ80(-1);                          // Select/reset Z80
    CPUReset();
    CPUSetZ80(0);                           // Select/reset 6502
    CPUReset();
    updateProcessorState();
}

static void updateProcessorState() {
    CPUSetZ80(mode);
    CPUEnable(cpurunning);                   
    CPUSetClock(fast ? 8 : 4);
}
