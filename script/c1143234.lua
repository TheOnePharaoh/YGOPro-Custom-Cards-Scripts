--ANTI-MATTER Undead King, Rarrthuts
function c1143234.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaf75),4,2)
	c:EnableReviveLimit()
	--spsummon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1143234,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1143234.condition)
	e1:SetTarget(c1143234.target)
	e1:SetOperation(c1143234.operation)
	c:RegisterEffect(e1)
	--destroy&banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1143234,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c1143234.descost)
	e2:SetTarget(c1143234.destg)
	e2:SetOperation(c1143234.desop)
	c:RegisterEffect(e2)
	--self xyz
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1143234,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,1143234)
	e3:SetCondition(c1143234.xyzcon)
	e3:SetTarget(c1143234.xyztg)
	e3:SetOperation(c1143234.xyzop)
	c:RegisterEffect(e3)
	if not c1143234.global_check then
		c1143234.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY,LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143234))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143234.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c1143234.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xaf75) and c:IsAbleToHand()
end
function c1143234.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c1143234.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1143234.thfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c1143234.thfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c1143234.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c1143234.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c1143234.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c1143234.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
end
function c1143234.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1143234.xyzfilter1(c,e,tp)
	return c:IsCode(1143234) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c1143234.xyzfilter2(c)
	return c:IsSetCard(0xaf75) and c:GetLevel()==4
end
function c1143234.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1143234.xyzfilter1,tp,LOCATION_REMOVED,0,1,nil,e,tp) 
		and Duel.IsExistingTarget(c1143234.xyzfilter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c1143234.xyzfilter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c1143234.xyzfilter2,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
end
function c1143234.xyzop(e,tp,eg,ep,ev,re,r,rp)
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
