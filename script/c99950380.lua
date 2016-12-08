--MSMM - Contract's Wish
function c99950380.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c99950380.condition)
	e1:SetCost(c99950380.cost)
	e1:SetTarget(c99950380.sptg)
	e1:SetOperation(c99950380.spop)
	c:RegisterEffect(e1)
end
function c99950380.spconfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsSetCard(9995) and c:GetLevel()==5
end
function c99950380.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99950380.spconfilter,tp,LOCATION_GRAVE,0,5,nil,e,tp) 
end
function c99950380.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c99950380.spfilter(c,e,tp)
	return c:IsSetCard(9995) and c:GetLevel()==10 and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c99950380.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c99950380.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function c99950380.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99950380.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,true,POS_FACEUP) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2,true)
	local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(Duel.GetMatchingGroupCount(c99950380.spconfilter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil)*500)
    e3:SetReset(RESET_EVENT+0xff0000)
    tc:RegisterEffect(e3,true)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_DEFENCE)
    tc:RegisterEffect(e4,true)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c99950380.tdcon)
	e5:SetOperation(c99950380.tdop)
	e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	tc:RegisterEffect(e5,true)
    local e6=Effect.CreateEffect(e:GetHandler())
	e6:SetDescription(aux.Stringid(99950380,0))
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c99950380.thcon)
	e6:SetTarget(c99950380.thtg)
	e6:SetOperation(c99950380.thop)
	e6:SetReset(RESET_EVENT+0xff0000)
	e6:SetLabelObject(tc)
	Duel.RegisterEffect(e6,tp)
	tc:RegisterFlagEffect(99950380,RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END,0,2)
	Duel.SpecialSummonComplete()
	end
end
function c99950380.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c99950380.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c99950380.thcon(e,tp,eg,ep,ev,re,r,rp)
  	local tc=e:GetLabelObject()
	return eg:IsContains(tc) and tc:GetFlagEffect(99950380)~=0
	and tc:IsPreviousPosition(POS_FACEUP) and tc:IsPreviousLocation(LOCATION_MZONE)
end
function c99950380.thfilter1(c)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsSetCard(9995) and c:IsAbleToHand()
end
function c99950380.thfilter2(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsSetCard(9995) and c:GetLevel()==10 and c:IsAbleToHand()
end
function c99950380.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99950380.thfilter1,tp,LOCATION_DECK,0,1,nil)
	and Duel.IsExistingMatchingCard(c99950380.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c99950380.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c99950380.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c99950380.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
	g1:Merge(g2)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
	end
end