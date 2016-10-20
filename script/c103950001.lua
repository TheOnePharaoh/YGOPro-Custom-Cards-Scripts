--Eon Scroll
function c103950001.initial_effect(c)

	--Mono	
	local e1=Effect.CreateEffect(c)	
	e1:SetDescription(aux.Stringid(103950001,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(c103950001.monocon)
	e1:SetOperation(c103950001.monoop)
	c:RegisterEffect(e1)
	
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
	
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c103950001.pdraw)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(103950001,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_DRAW)
	e4:SetCondition(c103950001.drcon)
	e4:SetTarget(c103950001.drtg)
	e4:SetOperation(c103950001.drop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
--Mono
function c103950001.monocon(e) return Duel.GetTurnCount()<3 and Duel.GetTurnPlayer()==e:GetHandler():GetControler() end
function c103950001.monofilter(c,g) return g:IsExists(c103950001.monofilter2,1,c,c:GetOriginalCode()) end
function c103950001.monofilter2(c,code) return c:GetOriginalCode() == code end
function c103950001.monoop(e,tp,eg,ep,ev,re,r,rp)
	local location = LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA
	local g=Duel.GetMatchingGroup(nil,tp,location,0,nil)
	if g:IsExists(c103950001.monofilter,1,nil,g) then
		Duel.Win(1-tp, nil)
	end
end

--Pre-draw
function c103950001.pdraw(e,tp,eg,ep,ev,re,r,rp)
	if tp~=ep then
		e:SetLabel(0)
		return
	end
	
	local c1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	local c2=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)

	if c1+c2<=5 then e:SetLabel(1) else e:SetLabel(0) end
end
--Draw condition
function c103950001.drcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RULE and e:GetLabelObject():GetLabel()==1 and Duel.GetFlagEffect(tp,103950001) < 3
end
--Draw target
function c103950001.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--Draw operation
function c103950001.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	
	local ct=Duel.GetFlagEffect(tp,103950001)
	Duel.RegisterFlagEffect(tp,103950001,0,0,ct+1)
end