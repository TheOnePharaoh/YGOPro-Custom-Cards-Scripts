--Eternal Lust - Asmodeus
function c66660010.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),4,2)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66660010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c66660010.sumcost)
	e1:SetTarget(c66660010.sumtg)
	e1:SetOperation(c66660010.sumop)
	c:RegisterEffect(e1)
		--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66660010,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c66660010.cost)
	e2:SetTarget(c66660010.target)
	e2:SetOperation(c66660010.operation)
	c:RegisterEffect(e2)
end
function c66660010.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c66660010.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c66660010.sumop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,666600020,0,0x4011,0,2500,8,RACE_DRAGON,ATTRIBUTE_DARK,POS_FACEUP,tp) then
		local token=Duel.CreateToken(tp,666600020)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e4,true)
end
end
function c66660010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c66660010.filter01(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c66660010.filter02,tp,LOCATION_DECK,0,1,nil,c:GetLevel(),c:GetRace(),c:GetAttack(),c:Get
Defense(),c:GetCode())
end
function c66660010.filter02(c,lv,rac,atk,def,code)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:GetLevel()==lv and c:GetRace()==rac and c:GetAttack()==atk and c:Get
Defense()==def and c:GetCode()~=code
end
function c66660010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66660010.filter01,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,tp,LOCATION_DECK)
end
function c66660010.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c66660010.filter01,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	if g:GetCount()<0 then return end
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ag=Duel.SelectMatchingCard(tp,c66660010.filter02,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel(),tc:GetRace(),tc:GetAttack(),tc:Get
Defense(),tc:GetCode())
	if ag:GetCount()>0 then 
		Duel.SendtoHand(ag,nil,REASON_EFFECT)
	end
end