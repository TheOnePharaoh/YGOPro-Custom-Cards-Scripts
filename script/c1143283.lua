--ANTI-MATTER Undead King, Ddofrt
function c1143283.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaf75),2,2)
	c:EnableReviveLimit()
	--spsummon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1143283,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1143283.condition)
	e1:SetTarget(c1143283.target)
	e1:SetOperation(c1143283.operation)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c1143283.indes)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c1143283.rmcost)
	e3:SetTarget(c1143283.rmtg)
	e3:SetOperation(c1143283.rmop)
	c:RegisterEffect(e3)
	--self xyz
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1143283,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,1143283)
	e4:SetCondition(c1143283.xyzcon)
	e4:SetTarget(c1143283.xyztg)
	e4:SetOperation(c1143283.xyzop)
	c:RegisterEffect(e4)
	if not c1143283.global_check then
		c1143283.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY,LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143283))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143283.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c1143283.spcfilter(c,e,tp)
	return c:IsSetCard(0xaf75) and c:GetLevel()==6 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1143283.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c1143283.spcfilter,tp,LOCATION_REMOVED,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_REMOVED)
end
function c1143283.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c1143283.spcfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
	if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,2,2,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c1143283.indes(e,re,rp)
	return re:GetOwner():IsSetCard(0xaf75)
end
function c1143283.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1143283.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf75)
end
function c1143283.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c1143283.desfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
		and e:GetHandler():GetFlagEffect(1143231)==0 end
	e:GetHandler():RegisterFlagEffect(1143231,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1143283.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
	local ct=g:GetCount()
	if ct==0 then return end
	if ct>2 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,c1143283.desfilter,tp,LOCATION_MZONE,0,1,ct,e:GetHandler())
	local ct2=Duel.Destroy(dg,REASON_EFFECT)
	if ct2>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:Select(tp,ct2,ct2,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c1143283.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1143283.xyzfilter1(c,e,tp)
	return c:IsCode(1143283) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c1143283.xyzfilter2(c)
	return c:IsSetCard(0xaf75) and c:GetLevel()==2
end
function c1143283.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1143283.xyzfilter1,tp,LOCATION_REMOVED,0,1,nil,e,tp) 
		and Duel.IsExistingTarget(c1143283.xyzfilter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c1143283.xyzfilter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c1143283.xyzfilter2,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
end
function c1143283.xyzop(e,tp,eg,ep,ev,re,r,rp)
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
