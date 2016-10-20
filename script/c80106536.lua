--The Panticle of Healing
function c80106536.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c80106536.sdcon)
	c:RegisterEffect(e2)
	--self destroy2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c80106536.sdcon)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80106536,0))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1)
	e4:SetCondition(c80106536.reccon)
	e4:SetTarget(c80106536.rectg)
	e4:SetOperation(c80106536.recop)
	c:RegisterEffect(e4)
	--recover2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80106536,1))
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCountLimit(1)
	e5:SetCondition(c80106536.reccon)
	e5:SetTarget(c80106536.rectg2)
	e5:SetOperation(c80106536.recop2)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80106536,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCondition(c80106536.spcon)
	e6:SetCost(c80106536.spcost)
	e6:SetTarget(c80106536.sptg)
	e6:SetOperation(c80106536.spop)
	c:RegisterEffect(e6)
end
function c80106536.sdfilter(c)
	return not c:IsFaceup() or not c:IsSetCard(0xca00)
end
function c80106536.sdcon(e)
	return Duel.IsExistingMatchingCard(c80106536.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80106536.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c80106536.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xca00)
end
function c80106536.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c80106536.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*300)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*300)
end
function c80106536.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c80106536.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Recover(tp,ct*300,REASON_EFFECT)
end
function c80106536.rectg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c80106536.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
end
function c80106536.recop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c80106536.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Recover(tp,ct*500,REASON_EFFECT)
end
function c80106536.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsPreviousLocation(LOCATION_HAND) and not e:GetHandler():IsReason(REASON_RETURN)
end
function c80106536.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c80106536.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,80106536,0,0xca00,4,1500,1500,RACE_SPELLCASTER,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c80106536.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,80106536,0,0xca00,4,1500,1500,RACE_SPELLCASTER,ATTRIBUTE_DARK) then
		c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e7:SetReset(RESET_EVENT+0x47e0000)
		e7:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e7,true)
	end
end