package main

import (
	"crypto/md5"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"os"
	"path/filepath"
	"strings"
	"time"
)

const (
	LayoutDateTime = "2006-01-02 15:04:05" //日期 + 时间

)

type (
	Token struct {
		App   string `json:"app"`   //程序名
		Token string `json:"token"` //令牌
		Max   int    `json:"max"`   //可用
		Has   int    `json:"has"`   //已用
		Log   string `json:"log"`   //扣减时间戳列表
	}

	Tokens struct {
		Tokens []Token `json:"tokens"`
	}
)

var (
	gPath = filepath.Dir(os.Args[0])
	//运行目录
	gConfig = gPath + "/cfg/config.json"
	//配置文件
	gTokens Tokens
	//token列表
)

func main() {
	//1.加载token配置信息
	err := LoadTokens(gConfig)
	if err != nil {
		fmt.Println(err.Error())
		return
	}

	gin.SetMode(gin.ReleaseMode)
	// 创建默认路由引擎
	r := gin.Default()

	// CheckToken?token=111：验证token有效性
	r.GET("/CheckToken", func(c *gin.Context) {
		idx := TokenExists(c.Query("token"))
		if idx < 0 {
			c.JSON(200, gin.H{
				"res": 1,
				"msg": "请填写Token!",
			})

			return
		}

		c.JSON(200, gin.H{
			"res": 0,
			"app": gTokens.Tokens[idx].App,
			"has": gTokens.Tokens[idx].Max - gTokens.Tokens[idx].Has,
			"log": gTokens.Tokens[idx].Log,
			"now": time.Now().Format(LayoutDateTime),
		})
	})

	// UseToken?token=111&id=222: 扣减一次token
	r.GET("/UseToken", func(c *gin.Context) {
		idx := TokenExists(c.Query("token"))
		if idx < 0 {
			c.JSON(200, gin.H{
				"res": 1,
				"msg": "请填写Token!",
			})

			return
		}

		if gTokens.Tokens[idx].Max <= gTokens.Tokens[idx].Has {
			c.JSON(200, gin.H{
				"res": 1,
				"msg": "Token授权已使用完毕!",
			})

			return
		}

		id := c.Query("id")
		//扣减流水
		if !VerifySerial(gTokens.Tokens[idx].Token, id) {
			c.JSON(200, gin.H{
				"res": 1,
				"msg": "无效的Token流水号!",
			})

			return
		}

		if gTokens.Tokens[idx].Log == "" {
			gTokens.Tokens[idx].Log = time.Now().Format(LayoutDateTime)
		} else {
			gTokens.Tokens[idx].Log = gTokens.Tokens[idx].Log + "|" + time.Now().Format(LayoutDateTime)
		}

		gTokens.Tokens[idx].Has = gTokens.Tokens[idx].Has + 1
		//扣减1次
		err := SaveTokens(gConfig)

		if err != nil {
			c.JSON(200, gin.H{
				"res": 1,
				"msg": "保存Token失败," + err.Error(),
			})

			return
		}

		c.JSON(200, gin.H{
			"res": 0,
			"app": gTokens.Tokens[idx].App,
			"has": gTokens.Tokens[idx].Max - gTokens.Tokens[idx].Has,
			"log": gTokens.Tokens[idx].Log,
		})
	})

	// 启动HTTP服务，默认在0.0.0.0:8080启动服务
	r.Run(":80")
}

// LoadTokens 2026-01-26 17:49:30
/*
 参数: cfg, 配置文件
 描述: 载入token配置信息
*/
func LoadTokens(cfg string) error {
	dt, err := os.ReadFile(cfg)
	if err != nil {
		return fmt.Errorf("读取配置失败: %w", err)
	}

	if err := json.Unmarshal(dt, &gTokens); err != nil {
		return fmt.Errorf("解析JSON失败: %w", err)
	}

	return nil
}

// SaveTokens 2026-01-26 17:49:53
/*
 参数: cfg, 配置文件
 描述: 保存token信息到cfg中
*/
func SaveTokens(cfg string) error {
	dt, err := json.MarshalIndent(gTokens, "", "  ")
	if err != nil {
		return fmt.Errorf("打包JSON失败: %w", err)
	}

	if err := os.WriteFile(cfg, dt, 0644); err != nil {
		return fmt.Errorf("保存配置失败: %w", err)
	}

	return nil
}

// TokenExists 2026-01-26 17:53:16
/*
 参数: token, 令牌
 描述: 验证token是否存在
*/
func TokenExists(token string) int {
	if strings.Trim(token, string([]byte{9, 10, 13, 32})) == "" {
		return -1
	}

	for i, t := range gTokens.Tokens {
		if t.Token == token {
			return i
		}
	}

	return -1
}

func MD5(v string) string {
	d := []byte(v)
	m := md5.New()
	m.Write(d)
	return hex.EncodeToString(m.Sum(nil))
}

// VerifySerial 2026-01-27 10:41:34
/*
 参数: token,令牌
 参数: id,流水标识
 描述: 验证id是否有效
*/
func VerifySerial(token, id string) bool {
	base := time.Now().Add(-1 * time.Minute)
	// 当前时间减1分钟

	target := time.Date(
		base.Year(),
		base.Month(),
		base.Day(),
		base.Hour(),
		base.Minute(),
		30,
		0,
		base.Location(),
	) //30秒

	newID := token + "_" + target.Format("2006-01-02 15:04:05")
	if MD5(newID) == id {
		return true
	}

	target = target.Add(-60 * time.Second) //前1分30秒
	newID = token + "_" + target.Format("2006-01-02 15:04:05")
	if MD5(newID) == id {
		return true
	}

	return false
}
