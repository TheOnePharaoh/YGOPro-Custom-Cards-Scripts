--Inscriber Mizumoji
function c915234232.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Rune Summon
	c:EnableReviveLimit()
	local r1=Effect.CreateEffect(c)
	r1:SetType(EFFECT_TYPE_FIELD)
	r1:SetCode(EFFECT_SPSUMMON_PROC)
	r1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	r1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	r1:SetCondition(c915234232.runcon)
	r1:SetOperation(c915234232.runop)
	r1:SetValue(0x4f000000)
	c:RegisterEffect(r1)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(915234232,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,915234232+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c915234232.thcost)
	e1:SetTarget(c915234232.thtg)
	e1:SetOperation(c915234232.thop)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c915234232.splimit)
	c:RegisterEffect(e2)
end
function c915234232.matfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER)
end
function c915234232.matfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xff0)
end
function c915234232.runfilter1(c)
	return c915234232.matfilter1(c) and Duel.IsExistingMatchingCard(c915234232.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,c)
end
function c915234232.runcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c915234232.runfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c915234232.runop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Group.CreateGroup()
	local g1=Duel.SelectMatchingCard(tp,c915234232.runfilter1,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
	g:Merge(g1)
	local g2=Duel.SelectMatchingCard(tp,c915234232.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
	g:Merge(g2)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x100000000)
end
function c915234232.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.Destroy(e:GetHandler(),REASON_COST)
end
function c915234232.thfilter(c)
	return c:IsSetCard(0xff0) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:GetCode()~=915234232
end
function c915234232.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c915234232.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c915234232.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c915234232.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c915234232.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_DECK)
end
