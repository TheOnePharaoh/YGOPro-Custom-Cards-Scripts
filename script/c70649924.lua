--ADE Skaard
function c70649924.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70649924,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c70649924.condition)
	e1:SetTarget(c70649924.target)
	e1:SetOperation(c70649924.operation)
	c:RegisterEffect(e1)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70649924,1))
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c70649924.hdcon)
	e2:SetTarget(c70649924.hdtg)
	e2:SetOperation(c70649924.hdop)
	c:RegisterEffect(e2)
end
function c70649924.filter(c,ec,tp)
	return c~=ec and c:IsRace(RACE_DRAGON) and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp
		and c:IsReason(REASON_BATTLE)
end
function c70649924.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c70649924.filter,1,nil,e:GetHandler(),tp)
end
function c70649924.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c70649924.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c70649924.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c70649924.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c70649924.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
