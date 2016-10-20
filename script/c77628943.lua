--Dirge, The Immortal Fighter of the Black Art
function c77628943.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0xba003),aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77628943.splimit)
	c:RegisterEffect(e1)
	--reborn preparation
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77628943,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c77628943.spcon)
	e2:SetCost(c77628943.spcost)
	e2:SetOperation(c77628943.spop)
	c:RegisterEffect(e2)
	--reborn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c77628943.spcon2)
	e3:SetOperation(c77628943.spop2)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77628943,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c77628943.atkcon)
	e4:SetOperation(c77628943.atkop)
	c:RegisterEffect(e4)
	--change battle target
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77628943,2))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c77628943.changecon)
	e5:SetCost(c77628943.changecost)
	e5:SetOperation(c77628943.changeop)
	c:RegisterEffect(e5)
end
function c77628943.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c77628943.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c77628943.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c77628943.spop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(77628943,RESET_EVENT+0x1fe0000,0,0)
end
function c77628943.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():GetFlagEffect(77628943)>0
end
function c77628943.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(77628943)
	Duel.SpecialSummon(c,225,tp,tp,false,false,POS_FACEUP_ATTACK)
end
function c77628943.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+225) and st<(SUMMON_TYPE_SPECIAL+230)
end
function c77628943.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(950)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c77628943.changecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetAttackTarget()~=e:GetHandler()
end
function c77628943.disfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE) and c:IsDiscardable()
end
function c77628943.changecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77628943.disfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c77628943.disfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c77628943.changeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local at=Duel.GetAttacker()
		if at:IsAttackable() and not at:IsImmuneToEffect(e) then
			Duel.CalculateDamage(at,c)
		end
	end
end
