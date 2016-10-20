-- Arcana Force XIX The Sun
function c123211.initial_effect(c)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123211,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c123211.cointg)
	e1:SetOperation(c123211.coinop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e4)
end
function c123211.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c123211.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	c123211.arcanareg(c,res)
end
function c123211.arcanareg(c,coin)
	--coin effect 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123211,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c123211.spcon)
	e1:SetTarget(c123211.sptg)
	e1:SetOperation(c123211.spop)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(123211,2))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_REPEAT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c123211.damcon)
	e2:SetValue(c123211.target)
	e2:SetOperation(c123211.operation)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetOperation(c123211.desop1)
	e3:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c123211.desop2)
	e4:SetReset(RESET_EVENT+0x17f0000)
	c:RegisterEffect(e4)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c123211.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():GetFlagEffectLabel(36690018)==1
end
function c123211.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,123212,0,0x4011,500,1000,1,RACE_FAIRY,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c123211.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,123212,0,0x4011,500,1000,1,RACE_FAIRY,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,123212)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c123211.damcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():GetFlagEffectLabel(36690018)==1
end
function c123211.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,ct*200)
end
function c123211.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	Duel.Damage(1-tp,ct*200,REASON_EFFECT)
end
function c123211.desop1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffectLabel(36690018)==0 then
		e:GetHandler():RegisterFlagEffect(123211,RESET_EVENT+0x17f0000,0,1)
	end
end
function c123211.desop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(123211)~=0 then
		local g=Duel.GetFieldGroup(tp,0xe,0xe)
		Duel.SendtoGrave(g,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*300,REASON_EFFECT)
		Duel.Damage(tp,ct*300,REASON_EFFECT)
	end
end