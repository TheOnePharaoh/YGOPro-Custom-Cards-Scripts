--Lizardfolk - Fighter
function c20161996.initial_effect(c)
	--Double ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20161996,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1)
	e1:SetCondition(c20161996.atkcon)
	e1:SetOperation(c20161996.atkop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e2:SetValue(LOCATION_DECKBOT)
	e2:SetCondition(c20161996.con)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20161996,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCountLimit(1)
	e3:SetCondition(c20161996.condition)
	e3:SetTarget(c20161996.sptg)
	e3:SetOperation(c20161996.spop)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c20161996.aclimit)
	e4:SetCondition(c20161996.actcon)
	c:RegisterEffect(e4)
end
function c20161996.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsControler(1-tp)
end
function c20161996.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
	end
end
function c20161996.confilter(c)
	return c:IsFaceup() and c:IsRace(RACE_REPTILE) and not c:IsCode(20161996)
end
function c20161996.con(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c20161996.confilter,c:GetControler(),LOCATION_MZONE,0,1,c)
end
function c20161996.cfilter(c)
	return c:IsPreviousLocation(LOCATION_HAND) or c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c20161996.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and eg:IsExists(c20161996.cfilter,1,nil,tp)
end
function c20161996.spfilter2(c,e,tp)
	return c:IsRace(RACE_REPTILE) and c:GetCode()~=20161996 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20161996.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20161996.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c20161996.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20161996.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()~=0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c20161996.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c20161996.cafilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xab90) or c:IsSetCard(0xab91) or c:IsSetCard(0xab92) and c:IsControler(tp)
end
function c20161996.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c20161996.cafilter(a,tp)) or (d and c20161996.cafilter(d,tp))
end
