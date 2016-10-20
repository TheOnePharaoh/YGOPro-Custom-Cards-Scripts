--ANTI-MATTER Dark Being, Dearrthr
function c1143233.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaf75),6,2)
	c:EnableReviveLimit()
	--spsummon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1143233,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1143233.condition)
	e1:SetTarget(c1143233.target)
	e1:SetOperation(c1143233.operation)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c1143233.indes)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1143233,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c1143233.tdcost)
	e3:SetTarget(c1143233.tdtg)
	e3:SetOperation(c1143233.tdop)
	c:RegisterEffect(e3)
	--self xyz
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1143233,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,1143233)
	e4:SetCondition(c1143233.xyzcon)
	e4:SetTarget(c1143233.xyztg)
	e4:SetOperation(c1143233.xyzop)
	c:RegisterEffect(e4)
	if not c1143233.global_check then
		c1143233.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY,LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143233))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143233.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c1143233.tdfilter(c)
	return c:IsSetCard(0xaf75) and c:IsAbleToDeck()
end
function c1143233.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c1143233.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3)
		and Duel.IsExistingTarget(c1143233.tdfilter,tp,LOCATION_REMOVED,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c1143233.tdfilter,tp,LOCATION_REMOVED,0,5,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c1143233.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.Draw(tp,3,REASON_EFFECT)
end
function c1143233.indes(e,re,rp)
	return re:GetOwner():IsSetCard(0xaf75)
end
function c1143233.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1143233.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf75)
end
function c1143233.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143233.desfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
		and e:GetHandler():GetFlagEffect(1143233)==0 end
	e:GetHandler():RegisterFlagEffect(1143233,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function c1143233.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	local ct=g:GetCount()
	if ct==0 then return end
	if ct>3 then ct=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,c1143233.desfilter,tp,LOCATION_ONFIELD,0,1,ct,e:GetHandler())
	local ct2=Duel.Destroy(dg,REASON_EFFECT)
	if ct2>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=g:Select(tp,ct2,ct2,nil)
		Duel.SendtoDeck(rg,nil,0,REASON_EFFECT)
	end
end
function c1143233.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1143233.xyzfilter1(c,e,tp)
	return c:IsCode(1143233) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c1143233.xyzfilter2(c)
	return c:IsSetCard(0xaf75) and c:GetLevel()==6
end
function c1143233.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1143233.xyzfilter1,tp,LOCATION_REMOVED,0,1,nil,e,tp) 
		and Duel.IsExistingTarget(c1143233.xyzfilter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c1143233.xyzfilter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c1143233.xyzfilter2,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
end
function c1143233.xyzop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=e:GetLabelObject()
	sg:RemoveCard(tc)
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		if sg:GetCount()>0 then 
			Duel.Overlay(tc,sg)
		end
	end
end