--Guan Yu, War God of the Sky Nirvana
function c44559808.initial_effect(c)
	c:SetUniqueOnField(1,0,44559808)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x2016),aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),true)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44559808,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c44559808.dracon)
	e2:SetTarget(c44559808.dratg)
	e2:SetOperation(c44559808.draop)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--cannot be effect target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--actlimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetValue(c44559808.aclimit)
	e5:SetCondition(c44559808.actcon)
	c:RegisterEffect(e5)
	--reborn preparation
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(44559808,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c44559808.spcon)
	e6:SetOperation(c44559808.spop)
	c:RegisterEffect(e6)
	--reborn
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCountLimit(1)
	e7:SetCondition(c44559808.spcon2)
	e7:SetOperation(c44559808.spop2)
	c:RegisterEffect(e7)
	--atkup
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(44559808,2))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetCondition(c44559808.atkcon)
	e8:SetOperation(c44559808.atkop)
	c:RegisterEffect(e8)
end
function c44559808.dracon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c44559808.drafilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2016) or c:IsSetCard(0x2017) or c:IsCode(44559811) or c:IsCode(44559832)
end
function c44559808.dratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	local ct=Duel.GetMatchingGroupCount(c44559808.drafilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct+1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c44559808.draop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(c44559808.drafilter,p,LOCATION_MZONE,0,nil)+1
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,aux.TRUE,p,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
end
function c44559808.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c44559808.actcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_BATTLE or (ph==PHASE_DAMAGE and not Duel.IsDamageCalculated())
end
function c44559808.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c44559808.spop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(44559808,RESET_EVENT+0x1fe0000,0,0)
end
function c44559808.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():GetFlagEffect(44559808)>0
end
function c44559808.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(44559808)
	Duel.SpecialSummon(c,225,tp,tp,true,false,POS_FACEUP_ATTACK)
end
function c44559808.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+225) and st<(SUMMON_TYPE_SPECIAL+230)
end
function c44559808.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end