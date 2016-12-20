--Hellformed Witchcrafter Jinx
function c77777785.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777785.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777785,2))
	e3:SetCountLimit(1)
	e3:SetOperation(c77777785.scop)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777785,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,77777785)
	e4:SetCost(c77777785.cost)
	e4:SetTarget(c77777785.target)
	e4:SetOperation(c77777785.operation)
	c:RegisterEffect(e4)
	--return
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77777785,1))
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,77777785+EFFECT_COUNT_CODE_OATH)
	e5:SetCost(c77777785.sscost)
	e5:SetTarget(c77777785.sstg)
	e5:SetOperation(c77777785.ssop)
	c:RegisterEffect(e5)
end

function c77777785.splimit(e,c,tp,sumtp,sumpos)
	return not (c:IsRace(RACE_FIEND)or c:IsSetCard(0x407)) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c77777785.scop(e,tp,eg,ep,ev,re,r,rp)
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

function c77777785.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.Destroy(e:GetHandler(),REASON_COST)
end

function c77777785.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777785.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c77777785.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777785.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c77777785.filter(c)
	return (c:IsSetCard(0x3e7)or c:IsSetCard(0x407)) and c:IsType(TYPE_MONSTER)and c:IsFaceup() and c:IsAbleToHand()and not c:IsCode(77777785)
end

function c77777785.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c77777785.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c77777785.sumfilter,tp,LOCATION_GRAVE,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77777785.sumfilter(c)
	return (c:IsSetCard(0x3e7)or c:IsSetCard(0x407)) and c:IsSummonable(true,nil)
end
function c77777785.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777785.sumfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
