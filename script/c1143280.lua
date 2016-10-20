--ANTI-MATTER Being, Crarkftzr
function c1143280.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaf75),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(c1143280.descon)
	e1:SetTarget(c1143280.destg)
	e1:SetOperation(c1143280.desop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c1143280.efilter)
	c:RegisterEffect(e2)
	--Self Synchro
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1143280,0))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetCountLimit(1,1143280)
	e3:SetCondition(c1143280.syncon)
	e3:SetTarget(c1143280.syntg)
	e3:SetOperation(c1143280.synop)
	c:RegisterEffect(e3)
	if not c1143280.global_check then
		c1143280.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetLabel(1143280)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD)
		ge2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge2:SetTargetRange(LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY,LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY)
		ge2:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143280))
		ge2:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge2,0)
	end
end
function c1143280.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO and e:GetHandler():GetFlagEffect(1143280)>0
end
function c1143280.desfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and not c:IsCode(1143280) and c:IsDestructable()
end
function c1143280.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingTarget(c1143280.desfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1143280.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c1143280.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function c1143280.efilter(e,re,rp,c)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
function c1143280.syncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1143280.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xaf75) and c:IsType(TYPE_TUNER)
		and Duel.IsExistingTarget(c1143289.filter2,tp,LOCATION_REMOVED,0,1,nil,e,tp,c:GetLevel())
end
function c1143280.filter2(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and c:IsFaceup() and c:IsSetCard(0xaf75) and not c:IsType(TYPE_TUNER)
		and Duel.IsExistingMatchingCard(c1143280.synfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,lv+clv)
end
function c1143280.synfilter(c,e,tp,lv)
	return c:IsCode(1143280) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1143280.syntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1143280.filter1,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c1143280.filter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c1143280.filter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c1143280.synop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if not tc1:IsRelateToEffect(e) or not tc2:IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(c1143280.synfilter,tp,LOCATION_REMOVED,0,nil,e,tp,tc1:GetLevel()+tc2:GetLevel())
	if sg:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_RETURN)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ssg=sg:Select(tp,1,1,nil)
	Duel.SpecialSummon(ssg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
end
