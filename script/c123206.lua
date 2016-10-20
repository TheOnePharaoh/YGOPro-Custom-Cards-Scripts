--Arcana Force X The Wheel of Fortune
function c123206.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c123206.spcon)
	c:RegisterEffect(e1)
	--only 1 can exists
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e2:SetCondition(c123206.excon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetTarget(c123206.sumlimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e6)
	--coin
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(123206,0))
	e7:SetCategory(CATEGORY_COIN)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetTarget(c123206.cointg)
	e7:SetOperation(c123206.coinop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c123206.sumlimit(e,c)
	return c:IsCode(123206)
end
function c123206.exfilter(c)
	return c:IsFaceup() and c:IsCode(123206)
end
function c123206.excon(e)
	return Duel.IsExistingMatchingCard(c123206.exfilter,0,LOCATION_MZONE,0,1,nil)
end
function c123206.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5) 
end
function c123206.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c123206.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c123206.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c123206.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	c123206.arcanareg(c,res)
end
function c123206.arcanareg(c,coin)
	--coin effect
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DRAW)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c123206.dtg)
	e1:SetCondition(c123206.con)
	e1:SetOperation(c123206.op)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_DRAW)
	e2:SetCondition(c123206.drcon)
	e2:SetTarget(c123206.drtg)
	e2:SetOperation(c123206.drop)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c123206.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW
		and e:GetHandler():GetFlagEffectLabel(36690018)==1
end
function c123206.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c123206.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c123206.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_DRAW
		and e:GetHandler():GetFlagEffectLabel(36690018)==0
end
function c123206.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c123206.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
