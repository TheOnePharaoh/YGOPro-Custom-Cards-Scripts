--Witchcrafter Diana
function c77777719.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x407),8,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777719.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777719,0))
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(c77777719.sccon)
--	e3:SetTarget(c77777719.sctg)
	e3:SetOperation(c77777719.scop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777719,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,77777719)
	e4:SetTarget(c77777719.sptg2)
	e4:SetOperation(c77777719.spop2)
	c:RegisterEffect(e4)
	--draw discard
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77777719,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,77777819)
	e5:SetCondition(c77777719.drwcon)
	e5:SetTarget(c77777719.drwtg)
	e5:SetOperation(c77777719.drwop)
	c:RegisterEffect(e5)
	--remove
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77777719,4))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,77777919)
	e6:SetCondition(c77777719.rmcon)
	e6:SetCost(c77777719.rmcost)
	e6:SetTarget(c77777719.rmtg)
	e6:SetOperation(c77777719.rmop)
	c:RegisterEffect(e6)
	--destroy S/T
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(77777719,3))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetCountLimit(1,77777619)
	e7:SetCost(c77777719.descost)
	e7:SetTarget(c77777719.destg)
	e7:SetOperation(c77777719.desop)
	c:RegisterEffect(e7)
	--destroy
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(77777719,5))
	e8:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCountLimit(1,77777519)
	e8:SetCondition(c77777719.dkcon)
	e8:SetCost(c77777719.dkcost)
	e8:SetTarget(c77777719.dktg)
	e8:SetOperation(c77777719.dkop)
	c:RegisterEffect(e8)
	
	
end

c77777719.pendulum_level=8

function c77777719.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x407) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777719.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function c77777719.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local scl=c:GetLeftScale()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(c:GetRightScale())
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e2:SetValue(scl)
	c:RegisterEffect(e2)
end



function c77777719.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end


function c77777719.spfilter(c,e,tp)
	return c:IsSetCard(0x407) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777719.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c77777719.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77777719.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77777719.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77777719.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end


function c77777719.drwcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end

function c77777719.drwtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c77777719.drwop(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.Draw(tp,1,REASON_EFFECT)
	if h1>0 then Duel.BreakEffect() end
	if h1>0 then
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end


function c77777719.descon(e)
	return e:GetHandler():GetOverlayCount()>=2
end
function c77777719.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) end
	c:RemoveOverlayCard(tp,c:GetOverlayCount(),c:GetOverlayCount(),REASON_COST)
end
function c77777719.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c77777719.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777719.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c77777719.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77777719.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77777719.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and not (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7))then
		if (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7)) then return end
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end


function c77777719.rmcon(e)
	return e:GetHandler():GetOverlayCount()>=3
end
function c77777719.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77777719.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c77777719.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c77777719.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777719.rmfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c77777719.rmfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c77777719.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end


function c77777719.dkcon(e)
	return e:GetHandler():GetOverlayCount()>=4
end
function c77777719.dkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) end
	c:RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c77777719.dktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,0,LOCATION_ONFIELD,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD)
end
function c77777719.dkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end