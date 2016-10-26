--Mystic Fauna Vinoceros
function c77777853.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x40a),1)
	c:EnableReviveLimit()
  --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777853,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c77777853.spcon)
	e1:SetTarget(c77777853.sptg)
	e1:SetOperation(c77777853.spop)
	c:RegisterEffect(e1)
  --To Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777853,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c77777853.tdtg)
	e2:SetOperation(c77777853.tdop)
	c:RegisterEffect(e2)
  --change target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777853,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c77777853.condition1)
	e3:SetTarget(c77777853.target1)
	e3:SetOperation(c77777853.activate1)
  c:RegisterEffect(e3)
end


function c77777853.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c77777853.spfilter(c,e,tp)
	return c:IsSetCard(0x40a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_XYZ+TYPE_SYNCHRO)
end
function c77777853.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777853.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77777853.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777853.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c77777853.filter(c)
	return c:IsSetCard(0x40a) and c:IsAbleToDeck()
end
function c77777853.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777853.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,nil,tp,LOCATION_GRAVE)
end
function c77777853.tdop(e,tp,eg,ep,ev,re,r,rp)
  local g2=Duel.SelectMatchingCard(tp,c77777853.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
	end
end


function c77777853.condition1(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c77777853.filter1(c,e)
	return c:IsCanBeEffectTarget(e)
end
function c77777853.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ag=eg:GetFirst():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	if chk==0 then return ag:IsExists(c77777853.filter1,1,at,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=ag:FilterSelect(tp,c77777853.filter1,1,1,at,e)
	Duel.SetTargetCard(g)
end
function c77777853.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangeAttackTarget(tc)
	end
end