--Flame Conjurer
function c42599681.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PYRO),5,2)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(42599681,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c42599681.damcon)
	e1:SetTarget(c42599681.damtg)
	e1:SetOperation(c42599681.damop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(42599681,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c42599681.sptg)
	e2:SetOperation(c42599681.spop)
	c:RegisterEffect(e2)
end
function c42599681.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE)
end
function c42599681.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,500)
end
function c42599681.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,500,REASON_EFFECT,true)
	Duel.Damage(tp,500,REASON_EFFECT,true)
	Duel.RDComplete()
end
function c42599681.spfilter(c,e,tp)
	return c:IsCode(42599677) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c42599681.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c42599681.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	local b2=Duel.IsExistingMatchingCard(c42599681.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (b1 or b2) end
	if b1 and b2 then
		local opt=Duel.SelectOption(tp,aux.Stringid(42599681,2),aux.Stringid(42599681,3))
		e:SetLabel(opt)
		e:GetHandler():RemoveOverlayCard(tp,opt+1,opt+1,REASON_COST)
	elseif b1 then
		Duel.SelectOption(tp,aux.Stringid(42599681,2))
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
		e:SetLabel(0)
	else
		Duel.SelectOption(tp,aux.Stringid(42599681,3))
		e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
		e:SetLabel(1)
	end
end
function c42599681.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=nil
	if e:GetLabel()==0 then
		tc=Duel.GetFirstMatchingCard(c42599681.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	else
		tc=Duel.GetFirstMatchingCard(c42599681.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	end
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end