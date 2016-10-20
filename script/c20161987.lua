--Strong Lizardfolk - Deathlord
function c20161987.initial_effect(c)
	c:SetSPSummonOnce(20161987)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xab90),aux.NonTuner(Card.IsRace,RACE_REPTILE),1)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c20161987.val)
	c:RegisterEffect(e1)
	--defup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c20161987.val)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(c20161987.aclimit)
	e4:SetCondition(c20161987.actcon)
	c:RegisterEffect(e4)
	--todeck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(20161987,0))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCondition(c20161987.tdcon)
	e5:SetTarget(c20161987.tdtg)
	e5:SetOperation(c20161987.tdop)
	c:RegisterEffect(e5)
	--Special Summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(20161987,1))
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCountLimit(1,20161987)
	e6:SetCondition(c20161987.sumcon)
	e6:SetCost(c20161987.sumcost)
	e6:SetTarget(c20161987.sumtg)
	e6:SetOperation(c20161987.sumop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e8)
end
function c20161987.valfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xab90) or c:IsSetCard(0xab91) or c:IsSetCard(0xab92)
end
function c20161987.val(e,c)
	return Duel.GetMatchingGroupCount(c20161987.valfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())*500
end
function c20161987.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c20161987.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c20161987.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c20161987.filter2(c)
	return c:IsAbleToDeck()
end
function c20161987.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and c20161987.filter2(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c20161987.filter2,tp,0,LOCATION_HAND+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c20161987.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
	end
end
function c20161987.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c20161987.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		g:RemoveCard(e:GetHandler())
		return g:GetCount()>0 and g:FilterCount(Card.IsAbleToDeck,nil)==g:GetCount()
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
end
function c20161987.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xab90) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20161987.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20161987.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c20161987.sumop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20161987.spfilter,tp,LOCATION_DECK,0,ft,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
