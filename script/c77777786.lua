--Hellformed Witchcrafter Jezzabel
function c77777786.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777786.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777786,2))
	e3:SetCountLimit(1)
	e3:SetOperation(c77777786.scop)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777786,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,77777786)
	e4:SetCost(c77777786.cost)
	e4:SetTarget(c77777786.target)
	e4:SetOperation(c77777786.operation)
	c:RegisterEffect(e4)
	--special summon rule
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetDescription(aux.Stringid(77777786,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,77777786+EFFECT_COUNT_CODE_OATH)
--	e5:SetCondition(c77777786.spcon)
	e5:SetTarget(c77777786.sptg)
	e5:SetOperation(c77777786.spop)
	c:RegisterEffect(e5)
	c77777786.spe=e5
end

function c77777786.splimit(e,c,tp,sumtp,sumpos)
	return not (c:IsRace(RACE_FIEND)or c:IsSetCard(0x407)) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c77777786.scop(e,tp,eg,ep,ev,re,r,rp)
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

function c77777786.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.Destroy(e:GetHandler(),REASON_COST)
end

function c77777786.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777786.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c77777786.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777786.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c77777786.filter(c)
	return (c:IsSetCard(0x3e7)or c:IsSetCard(0x407)) and c:IsType(TYPE_MONSTER)and c:IsFaceup() and c:IsAbleToHand()and not c:IsCode(77777786)
end


function c77777786.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (c:IsRace(RACE_FIEND)or c:IsRace(RACE_SPELLCASTER))
end
function c77777786.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777786.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c77777786.desfilter(c)
	return c:IsDestructable()
end

function c77777786.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c77777786.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c77777786.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 
	and Duel.IsExistingTarget(c77777786.desfilter,tp,0,LOCATION_ONFIELD,1,c)then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectTarget(tp,c77777786.desfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		Duel.Destroy(g,REASON_EFFECT)
	end
end