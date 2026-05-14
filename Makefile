################################################################################
#                                                                              #
# Copyright (c) 2026 Christian Gauger-Cosgrove                                 #
#                                                                              #
# Permission is hereby granted, free of charge, to any person obtaining a copy #
# of this software and associated documentation files (the "Software"), to     #
# deal in the Software without restriction, including without limitation the   #
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or  #
# sell copies of the Software, and to permit persons to whom the Software is   #
# furnished to do so, subject to the following conditions:                     #
#                                                                              #
# The above copyright notice and this permission notice (including the next    #
# paragraph) shall be included in all copies or substantial portions of the    #
# Software.                                                                    #
#                                                                              #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR   #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER       #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      #
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS #
# IN THE SOFTWARE.                                                             #
#                                                                              #
################################################################################



# Project-wide settings
debug ?= 0
icu ?= 1
NAME := libdatastore
BUILD_DIR := build
INCLUDE_DIR := include
LIB_DIR := lib
SRC_DIR := src

vpath %.c $(SRC_DIR)

# object file paths
OBJS := $(addprefix $(BUILD_DIR)/, $(patsubst %.c,%.o,$(notdir $(wildcard $(SRC_DIR)/*.c))))

# Compilers & Utilities
CC := gcc
AR := ar
RM := rm -rf

# General flag settings
#   CFLAGS
#     -std=c99: use ISO C99 standard
#     -fPIC: compile as position-independent code
#   CPPFLAGS
#     -D_GNU_SOURCE:
#     -DUNQLITE_ENABLE_THREADS: enable multi-threading code in UnQlite
#     -DSQLITE_ALLOW_COVERING_INDEX_SCAN=1: uses covering indicies for full
#         table scans
#     -DSQLITE_DEFAULT_AUTOMATIC_INDEX=1: enable automatic indexing of tables
#         without indicies for certain queries by default
#     -DSQLITE_DEFAULT_AUTOVACUUM=2: enable incremental automatic VACUUMing of
#         freed database pages by default
#     -DSQLITE_DEFAULT_FOREIGN_KEYS=1: enable enforcement of foreign key
#         constraints by default
#     -DSQLITE_DEFAULT_MEMSTATUS=1: enable the 'SQLITE_CONFIG_MEMSTATUS'
#         configuration interface features by default
#     -DSQLITE_DEFAULT_SYNCHRONOUS=3: sets the default database syncronization
#         mode to 'EXTRA' for enhanced database robustness
#     -DSQLITE_DEFAULT_WORKER_THREADS=5: number of auxiliary worker threads a
#         prepared statement may launch to assist with a query
#     -DSQLITE_DIRECT_OVERFLOW_READ: causes content contained in overflow pages
#         to be read directly from disk, bypassing the page cache for enhanced
#         performance of read transactions
#     -DSQLITE_DQS=0: disallows doubly-quoted strings in all contexts
#     -DSQLITE_ENABLE_API_ARMOR: activates code to attempt to detect misuse of
#         the SQLite API
#     -DSQLITE_ENABLE_BYTECODE_VTAB: enables the 'bytecode' and 'tables_used'
#         virtual tables
#     -DSQLITE_ENABLE_CARRAY: enables the carray() extension
#     -DSQLITE_ENABLE_COLUMN_METADATA: enables additional APIs to provide access
#         to table and query metadata
#     -DSQLITE_ENABLE_DBPAGE_VTAB: enables the 'SQLITE_DBPAGE' virtual table
#     -DSQLITE_ENABLE_DBSTAT_VTAB: enables the 'dbstat' virtual table
#     -DSQLITE_ENABLE_EXPLAIN_COMMENTS: adds logic to allow SQLite to insert
#         comments into the output of the EXPLAIN command
#     -DSQLITE_ENABLE_FTS3_PARENTHESIS: enables nested parentheses, the AND
#         operator, and the NOT operator in FTS3/FTS4 queries
#     -DSQLITE_ENABLE_FTS3_TOKENIZER: enables the two-argument FTS3/FTS4
#         tokenizer interface
#     -DSQLITE_ENABLE_FTS4: enables the FTS3/FTS4 full-text search engine
#     -DSQLITE_ENABLE_FTS5: enables the FTS5 full-text search engine
#     -DSQLITE_ENABLE_GEOPOLY: enables the Geopoly geospatial data extension
#     -DSQLITE_ENABLE_HIDDEN_COLUMNS: enables the hidden columns feature for
#         virtual tables
#     -DSQLITE_ENABLE_MATH_FUNCTIONS: enables the built-in SQL math functions
#     -DSQLITE_ENABLE_MEMORY_MANAGEMENT: enables the functionality of the
#         sqlite3_release_memory() interface
#     -DSQLITE_ENABLE_NORMALIZE: enables the sqlite3_normalize_sql() interface
#     -DSQLITE_ENABLE_NULL_TRIM: enables omitting the storage of NULL columns at
#         the end of a row, for space savings on disk
#     -DSQLITE_ENABLE_OFFSET_SQL_FUNC: enables the sqlite_offset() SQL function
#     -DSQLITE_ENABLE_ORDERED_SET_AGGREGATES: enables support for the 'WITHIN
#         GROUP ORDER BY' ordered-set aggregate syntax in SQL queries (which is
#         not standards compliant SQL)
#     -DSQLITE_ENABLE_PERCENTILE: enables the percentile extensions
#     -DSQLITE_ENABLE_PREUPDATE_HOOK: enables several APIs to provide callbacks
#         prior to changing a table
#     -DSQLITE_ENABLE_RTREE: enables the R*Tree spatial data indexing extensions
#     -DSQLITE_ENABLE_SNAPSHOT: enables the sqlite3_snapshot object and its
#         associated interfaces
#     -DSQLITE_ENABLE_SORTER_REFERENCES: enables sorter reference optimizations,
#         if configured at runtime using the 'SQLITE_CONFIG_SORTERREF_SIZE'
#         configuration interface
#     -DSQLITE_ENABLE_STAT4: enables additional logic for the query planner and
#         ANALYZE command to allow for better query plans to be chosen
#     -DSQLITE_ENABLE_STMTVTAB: enables the 'SQLITE_STMT' virtual table
#     -DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION: enables the EXPLAIN and EXPLAIN
#         QUERY PLAN command to analyze SQL statements which call unrecognized
#         SQL functions
#     -DSQLITE_ENABLE_UNLOCK_NOTIFY: enables the sqlite3_unlock_notify()
#         interface
#     -DSQLITE_LIKE_DOESNT_MATCH_BLOBS: causes the LIKE operator to always
#         return FALSE if either operand is a BLOB
#     -DSQLITE_MAX_WORKER_THREADS=50: the upper bound to the number of worker
#         threads a prepared statement may launch, when the default is modified
#         using sqlite3_limit()
#     -DSQLITE_OMIT_DEPRECATED: omit deprecated SQLite interfaces
#     -DSQLITE_OMIT_LOAD_EXTENSION: omit dynamic extension loading
#     -DSQLITE_SECURE_DELETE: securely deletes (by overwiting with zeroes)
#         content which has been deleted from the database
#     -DSQLITE_SOUNDEX: enables the soundex() SQL function
#     -DSQLITE_STRICT_SUBTYPE=1:
#     -DSQLITE_TEMP_STORE=2: enables storing temporary files to memory by
#         default, with the option to change the default using the 'temp_store'
#         command pragma
#     -DSQLITE_THREADSAFE=2: enables full multi-threaded function of SQLite by
#         default; the equivalent to issuing the 'SQLITE_CONFIG_MULTITHREAD' to
#         sqlite3_config()
#   ARFLAGS
#     rcs
CFLAGS := -std=c99 -fPIC
CPPFLAGS := -I$(INCLUDE_DIR)/ -D_GNU_SOURCE \
	-DUNQLITE_ENABLE_THREADS -DSQLITE_ALLOW_COVERING_INDEX_SCAN=1 \
	-DSQLITE_DEFAULT_AUTOMATIC_INDEX=1 -DSQLITE_DEFAULT_AUTOVACUUM=2 \
	-DSQLITE_DEFAULT_FOREIGN_KEYS=1 -DSQLITE_DEFAULT_MEMSTATUS=1 \
	-DSQLITE_DEFAULT_SYNCHRONOUS=3 -DSQLITE_DEFAULT_WORKER_THREADS=5 \
	-DSQLITE_DIRECT_OVERFLOW_READ -DSQLITE_DQS=0 -DSQLITE_ENABLE_API_ARMOR \
	-DSQLITE_ENABLE_BYTECODE_VTAB -DSQLITE_ENABLE_CARRAY \
	-DSQLITE_ENABLE_COLUMN_METADATA -DSQLITE_ENABLE_DBPAGE_VTAB \
	-DSQLITE_ENABLE_DBSTAT_VTAB -DSQLITE_ENABLE_EXPLAIN_COMMENTS \
	-DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS3_TOKENIZER \
	-DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_GEOPOLY \
	-DSQLITE_ENABLE_HIDDEN_COLUMNS -DSQLITE_ENABLE_MATH_FUNCTIONS \
	-DSQLITE_ENABLE_MEMORY_MANAGEMENT -DSQLITE_ENABLE_NORMALIZE \
	-DSQLITE_ENABLE_NULL_TRIM -DSQLITE_ENABLE_OFFSET_SQL_FUNC \
	-DSQLITE_ENABLE_ORDERED_SET_AGGREGATES -DSQLITE_ENABLE_PERCENTILE \
	-DSQLITE_ENABLE_PREUPDATE_HOOK -DSQLITE_ENABLE_RTREE \
	-DSQLITE_ENABLE_SNAPSHOT -DSQLITE_ENABLE_SORTER_REFERENCES \
	-DSQLITE_ENABLE_STAT4 -DSQLITE_ENABLE_STMTVTAB \
	-DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION -DSQLITE_ENABLE_UNLOCK_NOTIFY \
	-DSQLITE_LIKE_DOESNT_MATCH_BLOBS -DSQLITE_MAX_WORKER_THREADS=50 \
	-DSQLITE_OMIT_DEPRECATED -DSQLITE_OMIT_LOAD_EXTENSION \
	-DSQLITE_SECURE_DELETE -DSQLITE_SOUNDEX -DSQLITE_STRICT_SUBTYPE=1
-DSQLITE_TEMP_STORE=2 -DSQLITE_THREADSAFE=2
ARFLAGS := rcs

# ICU libraries (if we have them)
#   CPPFLAGS
#     -DSQLITE_ENABLE_ICU: enable the use of the International Components for
#         Unicode extension
ifeq ($(icu), 1)
	CPPFLAGS += -DSQLITE_ENABLE_ICU
endif

# Debug & Release build specific settings
#     Debug Builds
#     ============
#   CFLAGS
#     -g: include debugging symbols
#     -O0: no optimizations
#   CPPFLAGS
#     -DSQLITE_ENABLE_STMT_SCANSTATUS: enables the statement scan status
#         interfaces
#     -DDEBUG:
#
#     Release Builds
#     ==============
#   CFLAGS
#     -Ofast: optimize for speed
ifeq ($(debug), 1)
	CFLAGS += -g -O0
	CPPFLAGS += -DSQLITE_ENABLE_STMT_SCANSTATUS -DDEBUG
else
	CFLAGS += -Ofast
endif

.PHONY: all clean dir

all: $(NAME)

clean:
	$(RM) $(BUILD_DIR)
	$(RM) $(LIB_DIR)

$(LIB_DIR) : ; mkdir -p $(LIB_DIR)

$(NAME): $(OBJS)
	$(AR) $(ARFLAGS) $(patsubst %.o,$(LIB_DIR)/%.a,$(notdir $<)) $<

$(BUILD_DIR) : ; mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o : %.c | $(BUILD_DIR)
	$(CC) -o $@ -c $< $(CPPFLAGS) $(CFLAGS)

